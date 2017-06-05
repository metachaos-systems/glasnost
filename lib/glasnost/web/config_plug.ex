defmodule Glasnost.Plugs.PutConfig do
  import Plug.Conn
  alias Glasnost.RuntimeConfig

  def init(default), do: default

  def call(conn, _default)  do
    if RuntimeConfig.exists? do
      conn
        |> assign(:lang, RuntimeConfig.language)
        |> assign(:blog_authors, RuntimeConfig.get(:authors))
        |> assign(:about_blog_permlink, RuntimeConfig.get(:about_blog_permlink))
        |> assign(:about_blog_author, RuntimeConfig.get(:about_blog_author))
        |> assign(:default_post_image, RuntimeConfig.get(:default_post_image))
        |> assign(:menu, RuntimeConfig.get(:menu))
    else
      conn
    end
  end
end
