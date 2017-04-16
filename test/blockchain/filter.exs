defmodule Glasnost.PostImportFilterTest do
  use ExUnit.Case, async: true
  alias Glasnost.Worker.AuthorSync

  test "title regex whitelist works correctly" do
    titles = ["SomeTitle", "", "1337", "Some Title"]
     |> Enum.map(& %{"title" => &1})
    whitelist = ["SomeTitle", "1337"]
    assert [%{"title" => "SomeTitle"}, %{"title" => "1337"}] == Enum.filter(titles, &AuthorSync.matches_title_rule?(&1, :whitelist, whitelist))
  end

  test "title regex blacklist works correctly" do
    titles = ["SomeTitle", "", "1337", "Some Title"] |> Enum.map(& %{"title" => &1})
    blacklist = ["SomeTitle", "1337"]
    filtered = titles
      |> Enum.reject(&AuthorSync.matches_title_rule?(&1, :blacklist, blacklist))
      |> Enum.map(& &1["title"])
    assert ["",  "Some Title"] == filtered
  end
end
