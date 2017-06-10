defmodule Glasnost.Prototypes.OpsConsumer do
  alias Glasnost.ChannelBroadcaster
  use GenStage
  require Logger

  def start_link(args, options \\ []) do
    GenStage.start_link(__MODULE__, args, options)
  end

  def init(state) do
    {:consumer, state, subscribe_to: state[:subscribe_to]}
  end

  def handle_events(events, _from, state ) do
    bl = state[:blockchain]
    for op <- events do
      spawn(ChannelBroadcaster, :send, [op, blockchain: bl])
    end
    {:noreply, [], state}
  end

end
