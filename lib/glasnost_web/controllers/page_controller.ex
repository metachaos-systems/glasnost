defmodule GlasnostWeb.PageController do
  use GlasnostWeb, :controller
  import Ecto.Query

  def index(conn, _params) do
    render conn, "index.html"
  end

end
