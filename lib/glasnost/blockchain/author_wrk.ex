defmodule Glasnost.Worker.AuthorSync do
  use GenServer
  alias Glasnost.{Repo, RuntimeConfig, PostFilters, Post}
  import Logger

  def start_link(args, opts \\ []) do
    GenServer.start_link(__MODULE__, args, opts)
  end

  def init(config) do
    import Ecto.Query
    %{account_name: account_name, source_blockchain: source_blockchain} = config
    Logger.info("AuthorSync GenServer process for #{account_name} and #{source_blockchain} is being initialized...")
    Repo.delete_all(from c in Glasnost.Post, where: c.author == ^account_name and c.blockchain == ^source_blockchain)
    config = config
      |> put_in([:client_mod], RuntimeConfig.blockchain_client_mod(config.source_blockchain))
      |> put_in([:current_cursor], "")
    Process.send_after(self(), :tick, 1_000)
    {:ok, config}
  end

  def handle_info(:tick, state) do
     utc_now_str = NaiveDateTime.utc_now |> NaiveDateTime.to_iso8601 |> trim_trailing_ms
     %{account_name: account_name, current_cursor: current_cursor,
      client_mod: client_mod, filters: filters} = state
     {:ok, posts} = client_mod.get_discussions_by_author_before_date(account_name, current_cursor, utc_now_str, 100)
     posts = posts
      |> Enum.map(&parse_json_metadata/1)
      |> Enum.map(&extract_put_tags/1)
      |> Post.filter_by(:tags, filters[:tags])
      |> Post.filter_by(:title, filters[:title])
      |> Post.filter_by(:created, filters[:created])
      |> Enum.map( &Map.update!(&1, "created",  fn created -> NaiveDateTime.from_iso8601!(created) end))
      |> Enum.map( &Map.put(&1, "unix_epoch", &1["created"] |> DateTime.from_naive!("Etc/UTC") |> DateTime.to_unix()))
      |> Enum.map( &Glasnost.Post.prepare_post_for_publishing/1)
      
    for post <- posts do
         save_to_db(post, state.source_blockchain)
    end
    state = iterate(posts, state)
    {:noreply, state}
  end



  def parse_json_metadata(post) do
     result = case Poison.Parser.parse(post["json_metadata"]) do
       {:ok, map} -> map
       {:error, :invalid} -> %{}
     end
     put_in(post["json_metadata"], result)
  end

  def extract_put_tags(post) do
     put_in(post, ["tags"], post["json_metadata"]["tags"])
  end

  def trim_trailing_ms(date) when is_bitstring(date) do
     String.replace(date, ~r/\..+/, "")
  end

  def iterate(posts, state) do
    # for reasons unknown get_discussions_by_current_date returns variable number of posts, not a max of 100
    if length(posts) > 1 do
       Process.send_after(self(), :tick, 100, [])
       next_permlink = posts |> List.last() |> Map.get("permlink")
       put_in(state.current_cursor, next_permlink)
     else
       Process.send_after(self(), :tick, :timer.minutes(60), [])
       put_in(state.current_cursor, "")
     end
  end

  def save_to_db(post, source_blockchain) when is_map(post) do
     import Ecto.Query
     result =
       case Repo.one(from p in Glasnost.Post, where: p.id == ^post["id"] and p.blockchain == ^source_blockchain) do
         nil  -> %Glasnost.Post{blockchain: source_blockchain}
         comment -> comment
       end
       |> Glasnost.Post.changeset(post)
       |> Repo.insert_or_update

     case result do
       {:ok, _}       -> :ok
       {:error, _} -> :error
     end
  end

end
