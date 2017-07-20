defmodule Glasnost.Steem.StageSup do
  use Supervisor
  require Logger

  @config %Glasnost.AgentConfig{
      token: :steem,
      client: Steemex,
      schema: Glasnost.Steem,
      subscribe_to: []
    }

  def start_link do
    Supervisor.start_link(__MODULE__, :ok, name: :steem_flow_sup)
  end

  def init(:ok) do
    Logger.info("Flow supervisor for steem is initializing...")
    sscp = :steem_stage_stale_comments_producer
    smbp = :steem_stage_lookback_blocks_producer
    streaming_blocks_producer = Steemex.Stage.Blocks
    raw_ops_stage = Steemex.Stage.RawOps
    munged_ops_stage = Steemex.Stage.MungedOps
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
