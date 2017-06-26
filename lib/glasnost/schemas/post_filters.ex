defmodule Glasnost.Comment.Filters do

  def by(posts, _, rules) when is_nil(rules) or length(rules) === 0, do: posts
  def by(posts, filter, rules), do: apply_filter(posts, filter, rules)

  def apply_filter(posts, _, %{blacklist: [], whitelist: []}), do: posts

  def apply_filter(posts, :tags, rules) do
    import MapSet, only: [disjoint?: 2]
    wl = rules[:whitelist] || []
    bl = rules[:blacklist] || []
    wl_set = wl |> Enum.into(MapSet.new)
    bl_set = bl |> Enum.into(MapSet.new)
    matches_whitelist? = fn tags ->
      tag_set = tags |> Enum.into(MapSet.new)
      Enum.empty?(wl) or !disjoint?(tag_set, wl_set)
    end
    matches_blacklist? = fn tags ->
        tag_set = tags |> Enum.into(MapSet.new)
        !disjoint?(tag_set, bl_set)
    end
    Enum.filter(posts, fn %{"tags" => tags} ->
      matches_whitelist?.(tags)
      and
      !matches_blacklist?.(tags)
    end)
  end

  def apply_filter(posts, :title, rules) do
    wl = rules[:whitelist] || []
    bl = rules[:blacklist] || []
    matches_whitelist? = fn title ->
      Enum.empty?(wl) or matches_title_regex?(title, wl)
    end
    Enum.filter(posts, fn %{"title" => title} ->
      matches_whitelist?.(title) and !matches_title_regex?(title, bl)
    end)
  end

  def apply_filter(posts, :created, rules) do
    Enum.filter(posts, &matches_created_rule?(&1, rules))
  end

  def matches_title_regex?(title, regex_strings) when is_list(regex_strings) do
    # FIXME Malformed regexes will fail silently
    regexes = Enum.reduce(regex_strings, [], fn regex_str, acc ->
      case Regex.compile(regex_str) do
         {:ok, regex} -> acc ++ [regex]
         {:error, _} -> acc
      end
    end)
    Enum.reduce(regexes, false, fn regex, acc -> acc or String.match?(title, regex) end)
  end


  def matches_created_rule?(post, %{only_after: only_after, only_before: only_before}) do
    # offset is always zero, but required by ISO standard
    only_after = if only_after == "", do:  "1970-01-01", else: only_after
    only_before = if only_before == "", do:  "2038-01-01", else: only_before
    {:ok, only_after, 0} = DateTime.from_iso8601(only_after <> "T00:00:00Z")
    {:ok, only_before, 0} = DateTime.from_iso8601(only_before <> "T00:00:00Z")
    {:ok, created, 0} = DateTime.from_iso8601(post["created"] <> "Z")
    DateTime.compare(created, only_after) === :gt and DateTime.compare(created, only_before) === :lt
  end
end
