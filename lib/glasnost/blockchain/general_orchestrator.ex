defmodule Glasnost.Orchestrator.General do
  use Supervisor
  require Logger
  alias Glasnost.{AgentConfig}
  import Ecto.Query
  @golos_lookback_blocks :golos_lookback_blocks
  @golos_lookback_ops :golos_lookback_ops
  @golos_lookback_munged_ops :golos_lookback_munged_ops

  @golos_config %AgentConfig{
      client: Golos,
      schema: Glasnost.Golos,
      subscribe_to: [@golos_lookback_munged_ops],
      token: :golos,
  }

  @steem_config %AgentConfig{
      client: Steemex,
      schema: Glasnost.Steem,
      subscribe_to: [Steemex.Stage.MungedOps],
      token: :steem,
  }

  def start_link(args \\ [], options \\ []) do
    Supervisor.start_link(__MODULE__, args, options)
  end

  def init(arg) do
    Logger.info("Main orchestrator supervisor is initializing... ")
    children = build_children(:golos) ++ build_children(:steem)
    supervise(children, strategy: :one_for_one)
  end

  def build_children(:golos) do
    [
      worker(Glasnost.Stage.LookbackBlocks, [@golos_config, [name: @golos_lookback_blocks]]),
      worker(Golos.Stage.RawOps, [%{subscribe_to: [@golos_lookback_blocks]}, [name: @golos_lookback_ops]]),
      worker(Golos.Stage.MungedOps, [%{subscribe_to: [@golos_lookback_ops]}, [name: @golos_lookback_munged_ops]]),
      worker(Glasnost.Steemlike.RealtimeOpsSync, [%{config: @golos_config}], id: :golos),
    ]
  end

  def build_children(:steem) do
    [
      # worker(Glasnost.Steemlike.OpsConsumer, [%{config: @golos_config}], id: :golos),
    ]
  end

end
