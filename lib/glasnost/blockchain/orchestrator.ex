defmodule Glasnost.Orchestrator.General do
  use Supervisor
  require Logger
  import Ecto.Query

  def start_link(args \\ [], options \\ []) do
    Supervisor.start_link(__MODULE__, args, options)
  end

  def init(arg) do
    Logger.info("Main orchestrator supervisor is initializing... ")
    children = [
      supervisor(Glasnost.Golos.StageSup, []),
      supervisor(Glasnost.Steem.StageSup, []),
    ]
    supervise(children, strategy: :one_for_one)
  end


end
