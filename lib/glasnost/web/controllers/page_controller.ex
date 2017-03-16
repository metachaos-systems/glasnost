defmodule Glasnost.Web.PageController do
  use Glasnost.Web, :controller
  import Ecto.Query

  plug :put_lang, []

  def index(conn, _params) do
    blog_author = RuntimeConfig.blog_author
    posts = Glasnost.Repo.all(from c in Glasnost.Post, order_by: [desc: c.id])
    render conn, "posts.html", posts: posts, blog_author: blog_author
  end

  def show(conn, %{"permlink" => permlink}) do
    blog_author = RuntimeConfig.blog_author
    post = Glasnost.Repo.one(from c in Glasnost.Post, where: c.author == ^blog_author and c.permlink == ^permlink)
    {_, body, _} = Earmark.as_html(post.body)
    post = put_in(post.body, body)
    render conn, "post.html", post: post
  end

  def tag(conn, %{"tag" => tag}) do
    blog_author = RuntimeConfig.blog_author
    posts = Glasnost.Repo.all(from c in Glasnost.Post, where: ^tag in c.tags, order_by: [desc: c.id])
    render conn, "posts.html", posts: posts
  end

  def put_lang(conn, _) do
    assign(conn, :lang, RuntimeConfig.language)
  end

end
