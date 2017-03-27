defmodule Glasnost.Orchestrator.AuthorSyncSup do
  use Supervisor
  alias Glasnost.{Worker,Repo}
  import Ecto.Query

  def start_link(arg \\ []) do
    Supervisor.start_link(__MODULE__, arg)
  end

  def init(arg) do
    Repo.delete_all(from c in Glasnost.Post)
    children = :authors
      |> RuntimeConfig.get()
      |> AtomicMap.convert(safe: true)
      |> Enum.map(&validate_author_config/1)
      |> Enum.map(&put_in(&1,[:source_blockchain], RuntimeConfig.get(:source_blockchain)))
      |> Enum.map(&worker(Worker.AuthorSync, [&1], [id: "Wrk.AuthorSync:" <> &1.account_name]) )

    supervise(children, strategy: :one_for_one)
  end

  def validate_author_config(config) do
     # forcing a runtime pattern match exception if keys don't match
     # TODO: add value validation
     %{tags: %{blacklist: _, whitelist: _}, account_name: _ } = config
  end

end
