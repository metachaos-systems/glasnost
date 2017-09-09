defmodule Glasnost.CommentResolver do
  alias Glasnost.Repo
  import Ecto.Query

  def all(%{blockchain: blockchain, author: author}, _info) do
    schema = case blockchain do
      "steem" -> Glasnost.Steem.Comment
      "golos" -> Glasnost.Golos.Comment
    end
    q = from c in schema, order_by: [desc: c.created]
    q = if author do
      from c in q, where: c.author == ^author
    else
      q
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
