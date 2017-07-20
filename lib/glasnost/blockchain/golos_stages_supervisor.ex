defmodule Glasnost.Golos.StageSup do
  use Supervisor
  require Logger

  @config %Glasnost.AgentConfig{
      token: :golos,
      client: Golos,
      schema: Glasnost.Golos,
      subscribe_to: []
    }

  def start_link do
    Supervisor.start_link(__MODULE__, :ok, name: :golos_flow_sup)
  end

  def init(:ok) do
    Logger.info("Flow supervisor for golos is initializing...")
    sscp = :golos_stage_stale_comments_producer
    smbp = :golos_stage_lookback_blocks_producer
    streaming_blocks_producer = Golos.Stage.Blocks
    raw_ops_stage = Golos.Stage.RawOps
    munged_ops_stage = Golos.Stage.MungedOps
    block_producers = [smbp, streaming_blocks_producer]
    children = [
      worker(Glasnost.Stage.LookbackBlocks, [@config, [name: smbp]]),
      worker(streaming_blocks_producer, [[], [name: streaming_blocks_producer]]),
      worker(raw_ops_stage, [[subscribe_to: block_producers], [name: raw_ops_stage]]),
      worker(munged_ops_stage, [[subscribe_to: [raw_ops_stage]], [name: munged_ops_stage]]),
      worker(Glasnost.Steemlike.RealtimeOpsSync, [%{@config | subscribe_to: [munged_ops_stage]}]),
    ]

    supervise(children, strategy: :one_for_one, max_restarts: 10, max_seconds: 5)
  end

end
