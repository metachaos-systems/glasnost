defmodule Glasnost.BlockResolver do
  alias Glasnost.Repo
  import Ecto.Query
  import Glasnost.ResolverUtils, only: [select_schema: 1]

  def find(%{blockchain: blockchain, height: height, get_last: get_last}, _info) do
    schema = select_schema(blockchain)
    if get_last do
      max_known_height = Repo.one(from b in schema, select: max(b.height))
      {:ok, Repo.one(from b in schema, where: b.height == ^max_known_height)}
    else
      {:ok, Repo.find(schema, height: height)}
    end
  end

end
