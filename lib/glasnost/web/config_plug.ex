defmodule Glasnost.Plugs.PutConfig do
  import Plug.Conn

  def init(default), do: default

  def call(conn, _default)  do
    conn
      |> assign(:lang, RuntimeConfig.language)
      |> assign(:blog_authors, RuntimeConfig.get(:authors))
      |> assign(:about_blog_permlink, RuntimeConfig.get(:about_blog_permlink))
      |> assign(:about_blog_author, RuntimeConfig.get(:about_blog_author))
  end
end
