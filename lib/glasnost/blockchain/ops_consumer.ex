defmodule Glasnost.Steemlike.OpsConsumer do
  use GenStage
  require Logger

  def start_link(args, options \\ []) do
    GenStage.start_link(__MODULE__, args, options)
  end

  def init(%{config: config} = args \\ []) do
    Logger.info("Ops consumer for #{config.token} is initializing...")
    schema = config.schema
    new_config = config
      |> Map.put(:vote_schema, Module.concat(schema, Vote))
      |> Map.put(:comment_schema, Module.concat(schema, Comment))
    :timer.send_interval(10_000, :process_queue)
    {:consumer, %{config: new_config}, subscribe_to: args.subscribe_to}
  end

  def handle_events(events, _from, state) do
    client_mod = state.config.client_mod
    comments_to_update_new = events
      |> Enum.filter(& &1.metadata.type === :comment)
      |> Enum.map(&Map.take([:author, :permlink]))

    comments_to_update_votes = events
      |> Enum.filter(& &1.metadata.type === :vote)
      |> Enum.map(&Map.take([:author, :permlink]))

    commments_to_update = comments_to_update_new ++ comments_to_update_votes
      |> Enum.uniq

    for %{author: a, permlink: p} <- comments_to_update_new do
      client_mod.get_data_and_update(a, p)
    end

    {:noreply, [], state}
  end

end
