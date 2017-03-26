defmodule Glasnost.Orchestrator.AuthorSyncSup do
  use Supervisor
  alias Glasnost.Wrk

  def start_link(arg) do
    Supervisor.start_link(__MODULE__, arg)
  end

  def init(arg) do
    author_configs = RuntimeConfig.get(:authors) |> AtomicMap.convert(safe: false)
    Enum.each(author_configs, &validate_author_config/1)
    children = for config <- author_configs do
        worker(Wrk.AuthorSync, [config])
    end

    supervise(children, strategy: :simple_one_for_one)
  end

  def validate_author_config(config) do
     %{tags: %{blacklist: _, whitelist: _}, account_name: _, author_alias:_ } = config
  end
end
