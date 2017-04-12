defmodule Glasnost.Web.AdminController do
  use Glasnost.Web, :controller
  alias Glasnost.SimpleAuthenticator

  def index(conn, _params) do
    password_saved = SimpleAuthenticator.password_saved?
    password = if password_saved,
      do: "Login using your no-configuration password or restart Glasnost app",
      else: SimpleAuthenticator.get_password
    render conn, "index.html", password: password, password_saved: password_saved
  end

  def mark_password_as_saved(conn, _params)  do
    SimpleAuthenticator.mark_password_as_saved()
    conn
    |> put_flash(:info, "Password saved")
    |> redirect(to: "/admin")
  end
end
