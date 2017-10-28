defmodule Glasnost.Orchestrator.General do
  use Supervisor
  require Logger
  import Ecto.Query

  def start_link(args \\ [], options \\ []) do
    Supervisor.start_link(__MODULE__, args, options)
  end

  def init(config) do
    Logger.info("Main orchestrator for Steem and Golos is initializing... ")
    children = []
    golos_sup = if (config.disable_golos_stages) do
      []
    else
      [supervisor(Glasnost.Golos.StageSup, [])]
    end
    steem_sup = if (config.disable_steem_stages) do
      []
    else
      [supervisor(Glasnost.Steem.StageSup, [])]
    end

    children = children ++ golos_sup ++ steem_sup

    supervise(children, strategy: :one_for_one)
  end


end
