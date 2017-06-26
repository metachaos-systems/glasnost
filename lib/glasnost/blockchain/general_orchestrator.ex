defmodule Glasnost.Orchestrator.General do
  use Supervisor
  require Logger
  alias Glasnost.{Worker,Repo,RuntimeConfig}
  import Ecto.Query

  def start_link(args \\ [], options \\ []) do
    Supervisor.start_link(__MODULE__, args, options)
  end

  def init(arg) do
    Logger.info("General orchestrator is initializing... ")
    children = []
    supervise(children, strategy: :one_for_one)
  end

end
