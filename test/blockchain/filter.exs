defmodule Glasnost.PostImportFilterTest do
  use ExUnit.Case, async: true
  alias Glasnost.Post
  @posts [
    %{id: 1, tags: ["statistics", "stat", "elixir"]},
    %{id: 2, tags: ["programming", "elixir"]},
    %{id: 3, tags: ["golos", "steem","statistics"]},
    %{id: 4, tags: ["golos", "steem", "blockchain"]},
    %{id: 5, tags: ["programming", "erlang"]},
  ]

  @tag :skip
  test "title regex whitelist works correctly" do
    titles = ["SomeTitle", "", "1337", "Some Title"]
     |> Enum.map(& %{"title" => &1})
    whitelist = ["SomeTitle", "1337"]
    blacklist = ["SomeTitle", "1337"]
    assert [%{"title" => "SomeTitle"}, %{"title" => "1337"}] == Post.filter_by(@posts, :title, rules)
  end

  test "tag whitelist works correctly" do
    filtered = @posts
     |> Enum.filter(&AuthorSync.matches_tag_rule?(&1.tags, :whitelist, whitelist))
     |> Enum.map(& &1.id)
    assert [1,2,3,4] == filtered
  end

  test "tag blacklist works correctly" do
    blacklist = ["statistics", "stat"]
    filtered = @posts
     |> Enum.reject(&AuthorSync.matches_tag_rule?(&1.tags, :blacklist, blacklist))
     |> Enum.map(& &1.id)
    assert [2,4,5] == filtered
  end
end
