defmodule Glasnost.Web.CommentController do
  use Glasnost.Web, :controller
  alias Glasnost.Repo
  import Ecto.Query
  @posts_per_page 24

  plug :select_schema

  def index(conn, params) do
    q = from c in conn.assigns.comment_schema
    comments = Glasnost.Repo.all(q)
      |> Enum.map(&Map.from_struct/1)
      |> Enum.map(&Map.drop(&1, [:__meta__]))
    json conn, comments
  end

  def show(conn, %{"author" => a, "permlink" => p}) do
    comment = Glasnost.Repo.get_by(
      conn.assigns.comment_schema, author: a, permlink: p
    )
      |> Map.from_struct
      |> Map.drop([:__meta__])
    if comment do
      json conn, comment
    else
      send_resp(conn, 404, "")
    end
  end

  def search(conn, params) do
    author = params["author"]
    category = params["category"]
    q = from c in conn.assigns.comment_schema
    q = if category, do: (from c in q, where: c.category == ^category), else: q
    q = if author, do: (from c in q, where: c.author == ^author), else: q
    comments = Repo.all(q)
      |> Enum.map(&Map.from_struct/1)
      |> Enum.map(&Map.drop(&1, [:__meta__]))
    json conn, comments
  end

  def stats(conn, _params) do
    q_posts = from c in conn.assigns.comment_schema,
     where: not is_nil(c.title),
     select: c.id
    q_comments = from c in conn.assigns.comment_schema,
     where: is_nil(c.title),
     select: c.id
    json conn, %{
      post_count: length(Repo.all(q_posts)),
      comment_count: length(Repo.all(q_comments)),
    }
  end

  def select_schema(conn, _params) do
    schema = case String.slice(conn.request_path, 5, 5) do
      "golos" -> Glasnost.Golos.Comment
      "steem" -> Glasnost.Steem.Comment
    end
    assign conn, :comment_schema, schema
  end

end
