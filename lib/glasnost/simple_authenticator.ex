defmodule Glasnost.SimpleAuthenticator do
  use GenServer
  @pid :simple_authenticator

  def start_link(args \\ [], options \\ []) do
    GenServer.start_link(__MODULE__, args, name: @pid)
  end

  def get_password() do
      GenServer.call(@pid, :get_password )
  end

  def mark_password_as_saved() do
     GenServer.cast(@pid, :mark_password_as_saved)
  end

  def password_saved?() do
    GenServer.call(@pid, :password_saved)
  end

  def init(_args) do
     state = %{password: generate_random_password(), password_saved: false}
     {:ok, state}
  end

  def handle_call(:get_password, _from, state) do
    {:reply, state.password, state}
  end

  def handle_call(:password_saved, _from, state) do
    {:reply, state.password_saved, state}
  end


  def handle_cast(:mark_password_as_saved, state) do
    put_in(state.password_saved, true)
    {:noreply, state}
  end


  def generate_random_password() do
    :crypto.hash(:sha256, :rand.uniform |> Float.to_string) |> Base.encode16(case: :lower)
  end

end
