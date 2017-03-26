defmodule Glasnost.Orchestrator.AuthorSyncSup do
  use Supervisor
  alias Glasnost.Wrk

  def start_link(arg) do
    Supervisor.start_link(__MODULE__, arg)
  end

  def init(arg) do
    children = :authors
      |> RuntimeConfig.get()
      |> AtomicMap.convert(safe: true)
      |> Enum.map(&validate_author_config/1)
      |> Enum.map(&put_in(&1,[:source_blockchain], RuntimeConfig.get(:source_blockchain)))
      |> Enum.map(&worker(Wrk.AuthorSync, [&1]) )

    supervise(children, strategy: :simple_one_for_one)
  end

  def validate_author_config(config) do
     # forcing a runtime pattern match exception if keys don't match
     # TODO: add value validation
     %{tags: %{blacklist: _, whitelist: _}, account_name: _, author_alias: _ } = config
  end

end
