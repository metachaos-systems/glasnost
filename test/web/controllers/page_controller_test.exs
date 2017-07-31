defmodule GlasnostWeb.PageControllerTest do
  use GlasnostWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get conn, "/"
    assert html_response(conn, 200) =~ "Glasnost"
  end
end
