defmodule Glasnost.StatisticsResolver do
  alias Glasnost.Repo
  import Ecto.Query
  import Glasnost.ResolverUtils, only: [select_schema: 2]

  def all(%{blockchain: blockchain}, _info) do
    schema = select_schema(blockchain, :comment)
    {:ok, %{
      post_count: Repo.one(from c in schema, where: is_nil(c.parent_author), select: count(c.id)),
      comment_count: Repo.one(from c in schema, where: not is_nil(c.parent_author), select: count(c.id)),
      authors_count: Repo.one(from c in schema, select: count(c.author, :distinct)),
    }}
  end

end
