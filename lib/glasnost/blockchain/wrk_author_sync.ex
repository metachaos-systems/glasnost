defmodule Glasnost.Worker.AuthorSync do
  use GenServer
  alias Glasnost.Repo
  import Logger

  def start_link(args, opts \\ []) do
    GenServer.start_link(__MODULE__, args, opts)
  end

  def init(config) do
    import Ecto.Query
    %{account_name: account_name} = config
    Logger.info("AuthorSync GenServer process for #{account_name} is being initialized...")
    Repo.delete_all(from c in Glasnost.Post, where: c.author == ^account_name)

    config = config
      |> put_in([:client_mod], RuntimeConfig.blockchain_client_mod)
      |> put_in([:current_cursor], "")
    Process.send_after(self(), :tick, 1_000)
    {:ok, config}
  end

  def handle_info(:tick, state) do
     utc_now_str = NaiveDateTime.utc_now |> NaiveDateTime.to_iso8601 |> trim_trailing_ms
     %{account_name: account_name, current_cursor: current_cursor,
      client_mod: client_mod, filters: filters} = state
     {:ok, posts} = client_mod.get_discussions_by_author_before_date(account_name, current_cursor, utc_now_str, 100)
     IO.inspect "fetched #{length(posts)}"
     posts = posts
      |> Enum.map(&parse_json_metadata/1)
      |> Enum.map(&extract_put_tags/1)
      |> Enum.filter(&matches_tag_rule?(&1, filters.tags.whitelist))
      |> Enum.reject(&matches_tag_rule?(&1, filters.tags.blacklist))
      |> filter_by_title(filters.title)
      |> List.flatten
      |> filter_by_created(filters.created)

     for post <- posts do
       save_to_db(post)
     end
     state = iterate(posts, state)
     {:noreply, state}
  end

  def matches_tag_rule?(_, []), do: true

  def matches_tag_rule?(post, list) when is_list(list)  do
    tags_set = Enum.into(post["tags"], MapSet.new)
    filter_set = Enum.into(list, MapSet.new)
    !MapSet.disjoint?(tags_set, filter_set)
  end


  def filter_by_created(posts, %{only_after: "", only_before: ""}) do
    posts
  end

  def filter_by_created(posts, %{only_after: only_after, only_before: only_before}) do
    # offset is always zero, but required by ISO standard
    only_after = if only_after == "", do:  "1970-01-01", else: only_after
    only_before = if only_before == "", do:  "2038-01-01", else: only_before
    {:ok, only_after, 0} = DateTime.from_iso8601(only_after <> "T00:00:00Z")
    {:ok, only_before, 0} = DateTime.from_iso8601(only_before <> "T00:00:00Z")
    for post <- posts,
    {:ok, created, 0} = DateTime.from_iso8601(post["created"] <> "Z"),
      DateTime.compare(created, only_after) === :gt,
      DateTime.compare(created, only_before) === :lt,
      do: post
  end

  def filter_by_title(posts, %{whitelist: [], blacklist: []}) do
    posts
  end

  def filter_by_title(posts, %{whitelist: whls, blacklist: blls}) do
    regexes_compiler = &Enum.reduce(&1, [], fn regex_str, acc ->
      case Regex.compile(regex_str) do
         {:ok, regex} -> acc ++ [regex]
         {:error, _} -> acc
      end
    end)
    whls_regexes = regexes_compiler.(whls)
    blls_regexes = regexes_compiler.(blls)

    matches_any_wl_regex? = fn title ->
      case whls_regexes do
        [] -> true
        _ -> Enum.reduce(whls_regexes, false, fn regex, acc ->
        acc or String.match?(title, regex)
      end)
      end
    end

    matches_any_bl_regex? = fn title -> Enum.reduce(blls_regexes, false, fn regex, acc ->
        acc or String.match?(title, regex)
      end)
    end

    for post <- posts,
      matches_any_wl_regex?.(post["title"]),
      !matches_any_bl_regex?.(post["title"]),
       do: post
  end

  def trim_trailing_ms(date) when is_bitstring(date) do
     String.replace(date, ~r/\..+/, "")
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

  def save_to_db(post) when is_map(post) do
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

end
