defmodule Glasnost.StatisticsResolver do
  alias Glasnost.Repo

  def all(%{blockchain: blockchain}, _info) do
    schema = case blockchain do
      "steem" -> Glasnost.Steem.Comment
      "golos" -> Glasnost.Golos.Comment
    end
    {:ok, %{count: Repo.count(schema)}}
  end

end
