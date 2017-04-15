defmodule Glasnost.Orchestrator.AuthorSyncSup do
  use Supervisor
  require Logger
  alias Glasnost.{Worker,Repo,RuntimeConfig}
  import Ecto.Query

  def start_link(args \\ [], options \\ []) do
    Supervisor.start_link(__MODULE__, args, options)
  end

  def init(arg) do
    Logger.info("Orchestrator is initializing... ")
    Repo.delete_all(from c in Glasnost.Post)
    children = if RuntimeConfig.exists? do
      Logger.info("Config found, orchestrator is starting children... ")
      build_children()
    else
      Logger.info("Config is empty, orchestrator is not starting children... ")
      []
    end
    supervise(children, strategy: :one_for_one)
  end

  def build_children() do
    :authors
      |> RuntimeConfig.get()
      |> AtomicMap.convert(safe: false)
      |> Enum.map(&validate_author_config/1)
      |> Enum.map(&put_in(&1,[:source_blockchain], RuntimeConfig.get(:source_blockchain)))
      |> Enum.map(&worker(Worker.AuthorSync, [&1], [id: "Wrk.AuthorSync:" <> &1.account_name]) )
  end

  def validate_author_config(config) do
     # forcing a runtime pattern match exception if keys don't match
     # TODO: add value validation
     %{account_name: _, filters: _} = config
     config
  end

end
