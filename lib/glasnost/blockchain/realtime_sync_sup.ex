defmodule Glasnost.Prototypes.RealtimeSup do
  alias Glasnost.Prototypes
  use Supervisor
  require Logger

  def start_link(args \\ [], options \\ []) do
    Supervisor.start_link(__MODULE__, args, options)
  end

  def init(arg) do
    Logger.info("Full chain sync supervisor is initializing... ")
    struct_ops = Stage.StructuredOps.ProducerConsumer
    steem_ops_prod = [Module.concat(Steemex, struct_ops)]
    golos_ops_prod = [Module.concat(Golos, struct_ops)]
    children = [
      worker(Prototypes.OpsConsumer, [
          [blockchain: :steem, subscribe_to: steem_ops_prod], []
        ], id: :steem_ops_cons),
      worker(Prototypes.OpsConsumer, [
          [blockchain: :golos, subscribe_to: golos_ops_prod], []
        ],id: :golos_ops_cons)
    ]
    supervise(children, strategy: :one_for_one)
  end

end
