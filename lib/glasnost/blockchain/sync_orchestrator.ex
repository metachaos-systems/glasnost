defmodule Glasnost.Orchestrator.BlockchainSync do
  use GenServer
  @moduledoc """
  Executes a sync strategy based on the developer preferences in config.
  For example, a parallel import of blogs of multiple authors
  """

  def start_link(args \\ [], options \\ []) do
    GenServer.start_link(__MODULE__, args, options)
  end

  def init(state) do
     {:ok, state}
  end
end
