defmodule Glasnost.Web.CommentController do
  use Glasnost.Web, :controller
  import Ecto.Query
  @posts_per_page 24

  plug :choose_schema

  def index(conn, params) do
    q = from c in conn.assigns.comment_schema
    comments = Glasnost.Repo.all(q)
      |> Enum.map(&Map.from_struct/1)
      |> Enum.map(&Map.drop(&1, [:__meta__]))
    json conn, comments
  end

  def show(conn, %{"id" => id}) do
    [author, permlink] = String.split(id, "/")
    comment = Glasnost.Repo.get_by(conn.assigns.comment_schema, author: author, permlink: permlink)
    if comment do
      json conn, comment
    else
      send_resp(conn, 404, "")
    end
  end

  def choose_schema(conn, _params) do
    schema = case String.slice(conn.request_path, 1, 5) do
      "golos" -> Glasnost.Golos.Comment
      "steem" -> Glasnost.Steem.Comment
    end
    assign conn, :comment_schema, schema
  end

end
