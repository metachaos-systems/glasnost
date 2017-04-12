defmodule Glasnost.Web.AdminController do
  use Glasnost.Web, :controller
  alias Glasnost.SimpleAuthenticator

  def index(conn, _params) do
    password_saved = SimpleAuthenticator.password_saved?
    if password_saved do
      render conn, "index.html"
    else
      redirect conn, to: "/admin/onboarding"
    end
  end

  def onboarding(conn, _params) do
    password_saved = SimpleAuthenticator.password_saved?
    if password_saved do
      redirect conn, to: "/admin"
    else
      render conn, "onboarding.html", password: SimpleAuthenticator.get_password, password_saved: password_saved
    end
  end

  def mark_password_as_saved(conn, _params)  do
    SimpleAuthenticator.mark_password_as_saved()
    conn
    |> put_flash(:info, "Password saved")
    |> redirect(to: "/admin")
  end
end
