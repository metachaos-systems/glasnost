defmodule Glasnost.SimpleAuthenticator do
  use GenServer
  @pid :simple_authenticator

  def start_link(args \\ [], options \\ []) do
    GenServer.start_link(__MODULE__, args, name: @pid)
  end

  def get_password() do
      GenServer.call(@pid, :get_password )
  end

  def init(_args) do
     state = %{password: generate_random_password()}
     {:ok, state}
  end

  def handle_call(:get_password, _from, state) do
    {:reply, state.password, state}
  end

  def generate_random_password() do
    :crypto.hash(:sha256, :rand.uniform |> Float.to_string) |> Base.encode16(case: :lower)
  end

end
