defmodule Glasnost.Steemlike.RealtimeOpsSync do
  use GenStage
  require Logger
  alias Glasnost.{Golos, AgentConfig}

  def start_link(args, options \\ []) do
    GenStage.start_link(__MODULE__, args, options)
  end

  def init(config = %AgentConfig{} \\ []) do
    Logger.info("Ops consumer for #{config.token} is initializing...")
    schema = config.schema
    new_config = config
      |> Map.put(:vote_schema, Module.concat(schema, Vote))
      |> Map.put(:comment_schema, Module.concat(schema, Comment))
    {:consumer, new_config, subscribe_to: config.subscribe_to}
  end

  def handle_events(events, _from, state) do
    Logger.info("events arrived...")
    comments_to_update = events
      |> Enum.filter(& &1.metadata.type in [:comment, :vote])
      |> Enum.map(&Map.get(&1, :data))
      |> Enum.map(&Map.take(&1, [:author, :permlink]))
      |> Enum.uniq
      |> Enum.each(fn %{author: a, permlink: p} -> state.comment_schema.get_data_and_update(a, p) end)

    {:noreply, [], state}
  end

end
