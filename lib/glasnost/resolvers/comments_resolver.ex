defmodule Glasnost.CommentResolver do
  alias Glasnost.Repo
  import Ecto.Query

  def all(%{blockchain: blockchain, author: author, tag: tag}, _info) do
    schema = case blockchain do
      "steem" -> Glasnost.Steem.Comment
      "golos" -> Glasnost.Golos.Comment
    end
    q = (from c in schema, order_by: [desc: c.created])
      |> add_to_query(:tag, tag)
      |> add_to_query(:author, author)
    {:ok, Repo.all(q)}
  end

  def find(%{"blockchain" => blockchain, author: a, permlink: p}, _info) do
    schema = case blockchain do
      :steem -> Glasnost.Steem.Comment
      :golos -> Glasnost.Golos.Comment
    end
    {:ok, Repo.find(schema, author: a, permlink: p)}
  end

  def add_to_query(q, _, nil) do
    q
  end

  def add_to_query(q, :tag, tag) do
    from c in q, where: ^tag in c.tags
  end

  def add_to_query(q, :author, author) do
    from c in q, where: c.author == ^author
  end

end
