defmodule Glasnost.Prototypes.RealtimeSup do
  use Supervisor
  require Logger

  def start_link(args \\ [], options \\ []) do
    Supervisor.start_link(__MODULE__, args, options)
  end

  def init(arg) do
    Logger.info("Full chain sync supervisor is initializing... ")
    client = Module.concat(
      Steemex, Stage.StructuredOps.ProducerConsumer
    )
    ops_consumer_subs = [client]
    children = [
      worker(
      Glasnost.Prototypes.OpsConsumer,
        [[subscribe_to: ops_consumer_subs], []])
    ]
    supervise(children, strategy: :one_for_one)
  end

end
