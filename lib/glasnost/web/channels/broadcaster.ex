defmodule Glasnost.ChannelBroadcaster do
  alias Glasnost.Web.Endpoint
  def send(event, blockchain: :steem) do
    alias Steemex.StructuredOps.{Comment, Vote}
    {ev_data, ev_metadata} = event
    event_type = case ev_data do
      %Comment{} -> "new_comment"
      _ -> nil
    end
    if event_type do
      Endpoint.broadcast! "channel:steem_events", event_type, ev_data
    end
  end

  def send(event, :golos) do
    Glasnost.Endpoint.broadcast! "room:golos", "new_event", event
  end

end
