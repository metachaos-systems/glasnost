defmodule Glasnost.Web.PageControllerTest do
  use Glasnost.Web.ConnCase

  test "GET /", %{conn: conn} do
    conn = get conn, "/"
    assert html_response(conn, 200) =~ "Glasnost"
  end
end
