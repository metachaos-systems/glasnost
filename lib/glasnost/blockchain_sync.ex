defmodule Golos.Sync do
  use GenServer
  alias Glasnost.Repo

  def start_link(args \\ %{}) do
    GenServer.start_link(__MODULE__, args, [])
  end

  def init(args) do
    import Ecto.Query
    Repo.delete_all(from c in Glasnost.Post)
    blog_author = RuntimeConfig.get(:blog_author)

    state = %{current_cursor: "", blog_author: blog_author, client_mod: RuntimeConfig.blockchain_client_mod}

    Process.send_after(self(), :tick, 1_000)
    {:ok, state}
  end

  def handle_info(:tick, state) do
     utc_now_str = NaiveDateTime.utc_now |> NaiveDateTime.to_iso8601 |> String.replace(~r/\..+/, "")
     {:ok, posts} = state.client_mod.get_discussions_by_author_before_date(state.blog_author, state.current_cursor, utc_now_str, 100)
     posts = posts
      |> Enum.map(fn post -> update_in(post["json_metadata"], &Poison.Parser.parse! &1) end )
      |> Enum.map(fn post -> put_in(post, ["tags"], post["json_metadata"]["tags"]) end)
      |> filter_whitelisted(RuntimeConfig.get(:tags_whitelist))
      |> filter_blacklisted(RuntimeConfig.get(:tags_blacklist))

     for post <- posts do
       save_to_db(post)
     end
     state = iterate(posts, state)
     {:noreply, state}
  end

  def iterate(posts, state) do
    if length(posts) == 100 do
       Process.send_after(self(), :tick, 100, [])
       next_permlink = posts |> List.last() |> Map.get("permlink")
       put_in(state.current_cursor, next_permlink)
     else
       Process.send_after(self(), :tick, :timer.minutes(60), [])
       put_in(state.current_cursor, "")
     end
  end

  def save_to_db(post) do
     result =
       case Repo.get(Glasnost.Post, post["id"]) do
         nil  -> %Glasnost.Post{}
         comment -> comment
       end
       |> Glasnost.Post.changeset(post)
       |> Repo.insert_or_update

     case result do
       {:ok, _}       -> :ok
       {:error, _} -> :error
     end
  end

  def filter_whitelisted(posts, []) do
    posts
  end

  def filter_whitelisted(posts, tags) do
    for post <- posts,
      !disjoint_tags?(post["tags"], tags),
      do: post
  end

  def filter_blacklisted(posts, tags) do
    for post <- posts,
      disjoint_tags?(post["tags"], tags),
      do: post
  end

  def disjoint_tags?(tags1, tags2) do
    tags1_set = Enum.into(tags1, MapSet.new)
    tags2_set = Enum.into(tags2, MapSet.new)
    MapSet.disjoint?(tags1_set, tags2_set)
  end

end
