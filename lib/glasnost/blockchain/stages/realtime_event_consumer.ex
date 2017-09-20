defmodule Glasnost.Steemlike.EventHandler do
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
      |> Map.put(:block_schema, Module.concat(schema, Block))
    {:consumer, new_config, subscribe_to: config.subscribe_to}
  end

  def handle_events(events, _from, state) do
    Logger.info("#{length(events)} events arrived to #{state.token} event handler...")
    comments_to_update = events
      |> Enum.filter(& &1.metadata.type in [:comment, :vote])
      |> Enum.uniq_by(fn ev -> {ev.data.author, ev.data.permlink} end)
      |> Enum.each(fn ev -> spawn( fn -> state.comment_schema.react_to_event(ev) end) end)

    blocks_to_update = events
      |> Enum.filter(& &1.metadata.type === :block)
      |> Enum.each(fn ev -> spawn( fn -> state.block_schema.react_to_event(ev) end ) end)

    {:noreply, [], state}
  end

end
