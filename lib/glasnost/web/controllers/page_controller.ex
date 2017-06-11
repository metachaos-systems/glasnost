defmodule Glasnost.Web.PageController do
  use Glasnost.Web, :controller
  import Ecto.Query
  @posts_per_page 24

  plug :extract_and_put_page_num

  def streaming_demo(conn, _params) do
    render conn, "streaming_demo.html"
  end

  def index(conn, params) do
    q = from c in Glasnost.Post
    posts = q
      |> Glasnost.Repo.all()
      |> Enum.sort(&(&1.unix_epoch >= &2.unix_epoch))
      |> paginate_naively(conn.assigns.page_num)
    render conn, "posts.html", posts: posts
  end

  def show(conn, %{"permlink" => permlink, "author" => author }) do
    q = from c in Glasnost.Post,
     where: c.author == ^author and c.permlink == ^permlink
    post = Glasnost.Repo.one(q)
    render conn, "post.html", post: post
  end

  def tags(conn, params = %{"tag" => tag}) do
    q = from c in Glasnost.Post,
      order_by: [desc: c.id]
    posts = q
      |> Glasnost.Repo.all()
      |> Enum.filter(& tag in &1.tags)
      |> paginate_naively(conn.assigns.page_num)
    render conn, "posts.html", posts: posts
  end

  def authors(conn, params = %{"author" => author_name}) do
    q = from c in Glasnost.Post,
      where: c.author == ^author_name,
      order_by: [desc: c.id]

    posts = q
      |> Glasnost.Repo.all()
      |> paginate_naively(conn.assigns.page_num)
    render conn, "posts.html", posts: posts
  end

  def extract_and_put_page_num(conn, params) do
    case params do
      [] ->
        assign(conn, :page_num, 1)
      true ->
        res = params
         |> Map.get("page", "")
         |> Integer.parse()

        case res do
          {int, _} -> int
          :error -> 1
        end
        assign(conn, :page_num, res)
    end
  end

  def paginate_naively(xs, page_num) do
    amount = @posts_per_page*(page_num - 1)
    Enum.slice(xs, amount, @posts_per_page)
  end

end
