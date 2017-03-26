defmodule Glasnost.Worker.AuthorSync do
  use GenServer
  alias Glasnost.Repo
  import Logger

  def start_link(args, opts \\ []) do
    GenServer.start_link(__MODULE__, args, opts)
  end

  def init(config) do
    %{account_name: account_name} = config
    Logger.info("AuthorSync GenServer process for #{account_name} is being initialized...")
    import Ecto.Query
    Repo.delete_all(from c in Glasnost.Post, where: c.author == ^account_name)

    config = %{current_cursor: "",
      account_name: config.account_name,
      tags: config.tags,
      client_mod: RuntimeConfig.blockchain_client_mod}

    Process.send_after(self(), :tick, 1_000)
    {:ok, config}
  end

  def handle_info(:tick, state) do
     utc_now_str = NaiveDateTime.utc_now |> NaiveDateTime.to_iso8601 |> trim_trailing_ms
     %{account_name: account_name, current_cursor: current_cursor, client_mod: client_mod} = state
     {:ok, posts} = client_mod.get_discussions_by_author_before_date(account_name, current_cursor, utc_now_str, 100)
     posts = posts
      |> Enum.map(&parse_json_metadata/1)
      |> Enum.map(&extract_put_tags/1)
      |> filter_whitelisted(state.tags.whitelist)
      |> filter_blacklisted(state.tags.blacklist)
     for post <- posts do
       save_to_db(post)
     end
     state = iterate(posts, state)
     {:noreply, state}
  end

  def trim_trailing_ms(date) when is_bitstring(date) do
     String.replace(date, ~r/\..+/, "")
  end

  def parse_json_metadata(post) do
     update_in(post["json_metadata"], &Poison.Parser.parse!/1)
  end

  def extract_put_tags(post) do
     put_in(post, ["tags"], post["json_metadata"]["tags"])
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
