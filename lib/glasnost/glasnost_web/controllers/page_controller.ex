defmodule GlasnostWeb.PageController do
  use GlasnostWeb, :controller
  import Ecto.Query
  @posts_per_page 24

  plug :extract_and_put_page_num


  def index(conn, params) do
    render conn, "index.html"
  end

end
