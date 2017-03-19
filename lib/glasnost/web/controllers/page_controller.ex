defmodule Glasnost.Web.PageController do
  use Glasnost.Web, :controller
  import Ecto.Query
  @posts_per_page 25

  plug :put_lang, []
  plug :put_author, []

  def index(conn, params) do
    page_num = Map.get(params, "page", "0")
    q = from c in Glasnost.Post,
      where: c.author == ^conn.assigns.blog_author,
      order_by: [desc: c.id]
    posts = q
      |> Glasnost.Repo.all()
      |> paginate_naively(page_num)
    render conn, "posts.html", posts: posts, blog_author: conn.assigns.blog_author
  end

  def show(conn, %{"permlink" => permlink}) do
    q = from c in Glasnost.Post,
     where: c.author == ^conn.assigns.blog_author and c.permlink == ^permlink
    post = Glasnost.Repo.one(q)
    {_, body, _} = Earmark.as_html(post.body)
    post = put_in(post.body, body)
    render conn, "post.html", post: post
  end

  def tag(conn, params = %{"tag" => tag}) do
    page_num = Map.get(params, "page", "0")
    q = from c in Glasnost.Post,
      where: c.author == ^conn.assigns.blog_author,
      order_by: [desc: c.id]
    posts = q
      |> Glasnost.Repo.all()
      |> Enum.filter(& tag in &1.tags)
      |> paginate_naively(page_num)
    render conn, "posts.html", posts: posts
  end

  def put_lang(conn, _) do
    assign(conn, :lang, RuntimeConfig.language)
  end

  def put_author(conn, _) do
    assign(conn, :blog_author, RuntimeConfig.blog_author)
  end

  def paginate_naively(xs, page_num) do
    Enum.slice(xs, @posts_per_page*String.to_integer(page_num), @posts_per_page)
  end
end
