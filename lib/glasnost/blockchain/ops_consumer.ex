defmodule Glasnost.Steemlike.OpsConsumer do
  use GenStage
  require Logger

  def start_link(args, options \\ []) do
    GenStage.start_link(__MODULE__, args, options)
  end

  def init(%{config: config} = args \\ []) do
    Logger.info("Ops consumer for #{config.token} is initializing...")
    schema = state.config.schema
    config = state.config
      |> Map.put(:vote_schema, Module.concat(schema, Vote))
      |> Map.put(:comment_schema, Module.concat(schema, Comment))
    :timer.send_interval(10_000, :process_queue)
    {:consumer, %{config: state.config}, subscribe_to: args.subscribe_to}
  end

  def handle_events(events, _from, state) do
    comments = for event <- event, &(event.metadata.type === :comment) do
      event
    end
    votes = for event <- event, &(event.metadata.type === :vote) do
      event
    end
    {:noreply, [], state}
  end

  def handle_info(%{data: data, metadata: %{type: :comment}}, state) do
    {:noreply, [], state}
  end

  def handle_info(%{data: %{author: a, permlink: p}, metadata: %{type: :vote}}, state) do
    {:noreply, [], state}
  end


  def handle_info(msg, state) do
    {:noreply, [], state}
  end


end
