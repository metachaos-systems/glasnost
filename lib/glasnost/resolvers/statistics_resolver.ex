defmodule Glasnost.StatisticsResolver do
  alias Glasnost.Repo
  import Ecto.Query

  def all(%{blockchain: blockchain}, _info) do
    schema = case blockchain do
      "steem" -> Glasnost.Steem.Comment
      "golos" -> Glasnost.Golos.Comment
    end
    {:ok, %{
      post_count: Repo.count(from c in schema, where: is_nil(c.parent_author)),
      comment_count: Repo.count(schema)
    }}
  end

end
