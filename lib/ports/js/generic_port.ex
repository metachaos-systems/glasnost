defmodule Exos.Proc do
  use GenServer
  @moduledoc """
    Generic port as gen_server wrapper :
    send a message at init, first message is remote initial state
    cast and call encode and decode erlang binary format
  """
  def start_link(args, options \\ []) do
    # FIXME GolosJS name should be configured in the supervisor
    GenServer.start_link(__MODULE__, args, name: GolosJS)
  end
  def init({cmd,init,opts}) do
    port = Port.open({:spawn,'#{cmd}'}, [:binary,:exit_status, packet: 4] ++ opts)
    send(port,{self,{:command,:erlang.term_to_binary(init)}})
    {:ok,port}
  end
  def handle_info({port,{:exit_status,0}},port), do: {:stop,:normal,port}
  def handle_info({port,{:exit_status,_}},port), do: {:stop,:port_terminated,port}
  def handle_info(_,port), do: {:noreply,port}
  def handle_cast(term,port) do
    send(port,{self,{:command,:erlang.term_to_binary(term)}})
    {:noreply,port}
  end
  def handle_call(term,_reply_to,port) do
    send(port,{self,{:command,:erlang.term_to_binary(term)}})
    res = receive do {^port,{:data,b}}->:erlang.binary_to_term(b) end
    {:reply,res,port}
  end
end
