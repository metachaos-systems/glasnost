defmodule Glasnost.Web.TagController do
  use Glasnost.Web, :controller
  import Ecto.Query

  plug :put_lang, []
  
  def show(conn, %{"tag" => tag}) do
    blog_author = RuntimeConfig.blog_author
    posts = Glasnost.Repo.all(from c in Glasnost.Post, where: ^tag in c.tags)
    render conn, "tag.html", posts: posts
  end

  def put_lang(conn, _) do
    assign(conn, :lang, RuntimeConfig.language)
  end

end
