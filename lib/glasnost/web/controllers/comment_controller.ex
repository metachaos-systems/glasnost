defmodule Glasnost.Web.CommentController do
  use Glasnost.Web, :controller
  import Ecto.Query
  @posts_per_page 24

  def index(conn, params) do
    q = from c in Glasnost.Golos.Comment
    comments = Glasnost.Repo.all(q)
      |> Enum.map(&Map.from_struct/1)
      |> Enum.map(&Map.drop(&1, [:__meta__]))
    IO.inspect comments
    json conn, comments
  end

  def show(conn, %{"id" => id}) do
    [author, permlink] = String.split(id, "/")
    comment = Glasnost.Repo.get_by(Glasnost.Golos.Comment, author: author, permlink: permlink)
    if comment do
      json conn, comment
    else
      send_resp(conn, 404, "")
    end
  end

end
