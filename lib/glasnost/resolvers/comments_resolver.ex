defmodule Glasnost.CommentResolver do
  alias Glasnost.Repo
  import Ecto.Query

  def all(%{blockchain: blockchain, author: author}, _info) do
    schema = case blockchain do
      "steem" -> Glasnost.Steem.Comment
      "golos" -> Glasnost.Golos.Comment
    end
    q = if author do
      from c in schema, where: c.author === ^author, order_by: [desc: c.created]
    else
      from c in schema, order_by: [desc: c.created], limit: 1_000
    end
    {:ok, Repo.all(q)}
  end

  def find(%{"blockchain" => blockchain, author: a, permlink: p}, _info) do
    schema = case blockchain do
      :steem -> Glasnost.Steem.Comment
      :golos -> Glasnost.Golos.Comment
    end
    {:ok, Repo.find(schema, author: a, permlink: p)}
  end
end
