defmodule Glasnost.Orchestrator.General do
  use Supervisor
  require Logger
  alias Glasnost.{AgentConfig}
  import Ecto.Query

  @golos_config %AgentConfig{
      client: Golos,
      schema: Golos,
      subscribe_to: [Golos.Stage.MungedOps],
      token: :golos,
  }

  @steem_config %AgentConfig{
      client: Steemex,
      schema: Steem,
      subscribe_to: [Steemex.Stage.MungedOps],
      token: :steem,
  }

  def start_link(args \\ [], options \\ []) do
    Supervisor.start_link(__MODULE__, args, options)
  end

  def init(arg) do
    Logger.info("Main orchestrator supervisor is initializing... ")

    children = [
      worker(Glasnost.Steemlike.OpsConsumer, [%{config: @steem_config}], id: :steem),
      worker(Glasnost.Steemlike.OpsConsumer, [%{config: @golos_config}], id: :golos),
    ]
    supervise(children, strategy: :one_for_one)
  end

end
