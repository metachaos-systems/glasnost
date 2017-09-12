defmodule Glasnost.CommentResolver do
  alias Glasnost.Repo
  import Ecto.Query

  def all(args, _info) do
    blockchain = args[:blockchain]
    author = args[:author]
    tag = args[:tag]
    is_post = args[:is_post]
    category = args[:category]
    schema = select_schema(blockchain)
    q = (from c in schema, order_by: [desc: c.created])
      |> add_to_query(:tag, tag)
      |> add_to_query(:category, category)
      |> add_to_query(:author, author)
      |> add_to_query(:is_post, is_post)
    {:ok, Repo.all(q)}
  end

  def find(%{"blockchain" => blockchain, author: a, permlink: p}, _info) do
    schema = select_schema(blockchain)
    {:ok, Repo.find(schema, author: a, permlink: p)}
  end

  def add_to_query(q, _, nil) do
    q
  end


  def add_to_query(q, :is_post, false), do: q
  def add_to_query(q, :is_post, true) do
    from c in q, where: is_nil(c.parent_author)
  end

  def add_to_query(q, :category, category) do
    from c in q, where: c.category == ^category
  end

  def add_to_query(q, :tag, tag) do
    from c in q, where: ^tag in c.tags
  end

  def add_to_query(q, :author, author) do
    from c in q, where: c.author == ^author
  end

  def select_schema(blockchain) when is_binary(blockchain) do
    case blockchain do
      "steem" -> Glasnost.Steem.Comment
      "golos" -> Glasnost.Golos.Comment
    end
  end

end
