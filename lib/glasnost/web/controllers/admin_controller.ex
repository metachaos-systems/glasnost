defmodule Glasnost.Web.AdminController do
  use Glasnost.Web, :controller
  alias Glasnost.{SimpleAuthenticator,RuntimeConfig}

  def index(conn, _params) do
    password_saved = SimpleAuthenticator.password_saved?
    if password_saved do
      render conn, "index.html"
    else
      redirect conn, to: "/admin/onboarding"
    end
  end

  def command_and_control(conn, %{"admin_ops" => admin_ops}) do
    authorized? = admin_ops["password"] == SimpleAuthenticator.get_password()
    conn = if authorized? do
      case RuntimeConfig.update(admin_ops["config_url"]) do
        {:ok, _config} ->
          put_flash(conn, :info, "Config updated")
        {:error, reason} ->
          put_flash(conn, :info, "Config wasn't updated: #{reason}")
      end
    else
      put_flash(conn, :error, "Error: password doesn't match")
    end
    redirect(conn, to: "/admin")
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
