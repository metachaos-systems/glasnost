defmodule Glasnost.PostImportFilterTest do
  use ExUnit.Case, async: true
  alias Glasnost.Worker.AuthorSync

  test "title regex whitelist works correctly" do
    titles = ["SomeTitle", "", "1337", "Some Title"]
     |> Enum.map(& %{"title" => &1})
    config = %{whitelist: ["SomeTitle", "1337"], blacklist: []}
    assert [%{"title" => "SomeTitle"}, %{"title" => "1337"}] == AuthorSync.filter_by_title(titles, config)
  end

  test "title regex blacklist works correctly" do
    titles = ["SomeTitle", "", "1337", "Some Title"]
     |> Enum.map(& %{"title" => &1})
    config = %{whitelist: [], blacklist: ["SomeTitle", "1337"]}
    assert [%{"title" => ""}, %{"title" => "Some Title"}] == AuthorSync.filter_by_title(titles, config)
  end
end
