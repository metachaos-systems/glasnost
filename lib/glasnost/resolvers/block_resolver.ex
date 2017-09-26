defmodule Glasnost.BlockResolver do
  alias Glasnost.Repo
  import Ecto.Query
  import Glasnost.ResolverUtils, only: [select_schema: 1]

  def find(%{blockchain: blockchain, height: height}, _info) do
    schema = select_schema(blockchain)
    {:ok, Repo.find(schema, height: height)}
  end

end
