defmodule Glasnost.Web.PageController do
  use Glasnost.Web, :controller
  import Ecto.Query
  @posts_per_page 24

  def index(conn, params) do
    page_num = extract_page_num(params)
    q = from c in Glasnost.Post
    posts = q
      |> Glasnost.Repo.all()
      |> Enum.sort(&(&1.unix_epoch >= &2.unix_epoch))
      |> paginate_naively(page_num)
    render conn, "posts.html", posts: posts, current_page: page_num
  end

  def show(conn, %{"permlink" => permlink, "author" => author }) do
    q = from c in Glasnost.Post,
     where: c.author == ^author and c.permlink == ^permlink
    post = Glasnost.Repo.one(q)
    render conn, "post.html", post: post
  end

  def tags(conn, params = %{"tag" => tag}) do
    page_num = extract_page_num(params)
    q = from c in Glasnost.Post,
      order_by: [desc: c.id]
    posts = q
      |> Glasnost.Repo.all()
      |> Enum.filter(& tag in &1.tags)
      |> paginate_naively(page_num)
    render conn, "posts.html", posts: posts, current_page: page_num
  end

  def authors(conn, params = %{"author" => author_name}) do
    page_num = extract_page_num(params)
    q = from c in Glasnost.Post,
      where: c.author == ^author_name,
      order_by: [desc: c.id]

    posts = q
      |> Glasnost.Repo.all()
      |> paginate_naively(page_num)
    render conn, "posts.html", posts: posts, current_page: page_num
  end

  def extract_page_num(params) do
    res = params
     |> Map.get("page", "")
     |> Integer.parse()

    case res do
      {int, _} -> int
      :error -> 1
    end
  end

  def paginate_naively(xs, page_num) do
    amount = @posts_per_page*(page_num - 1)
    Enum.slice(xs, amount, @posts_per_page)
  end

end
