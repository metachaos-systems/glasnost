defmodule Glasnost.ChannelBroadcaster do
  alias Glasnost.Web.Endpoint

  def send(event, blockchain: :steem) do
    alias Steemex.StructuredOps.{Comment, Vote}
    {ev_data, ev_metadata} = event
    {event_type, ev_data, ev_metadata} = case ev_data do
      %Comment{author: author, permlink: permlink} ->
        {:ok, comment} = Steemex.get_content(author, permlink)
        {"new_comment", comment, ev_metadata}
      _ -> {nil, nil, nil}
    end
    if event_type do
      Endpoint.broadcast! "channel:steem_events", event_type, ev_data
    end
  end
  

  def send(event, :golos) do
    Glasnost.Endpoint.broadcast! "room:golos", "new_event", event
  end

end
