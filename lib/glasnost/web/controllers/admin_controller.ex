defmodule Glasnost.Web.AdminController do
  use Glasnost.Web, :controller
  alias Glasnost.SimpleAuthenticator
  
  def index(conn, _params) do
    password_saved = SimpleAuthenticator.password_saved?
    password = SimpleAuthenticator.get_password
    render conn, "index.html", password: password, password_saved: password_saved
  end

  def remove_password_from_index do
    SimpleAuthenticator.mark_password_as_saved()
  end
end
