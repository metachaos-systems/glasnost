defmodule Glasnost.BlockResolver do
  alias Glasnost.Repo
  import Ecto.Query
  import Glasnost.ResolverUtils, only: [select_schema: 2]

  def find(args, _info) do
    blockchain = args[:blockchain]
    height = args[:height]
    get_last = args[:get_last]
    schema = select_schema(blockchain, :block)
    if get_last do
      max_known_height = Repo.one(from b in schema, select: max(b.height))
      {:ok, Repo.one(from b in schema, where: b.height == ^max_known_height)}
    else
      {:ok, Repo.find(schema, height: height)}
    end
  end

end
