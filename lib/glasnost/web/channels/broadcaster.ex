defmodule Glasnost.ChannelBroadcaster do
  alias Glasnost.Web.Endpoint
  @golos_events "channel:golos_events"
  @steem_events "channel:steem_events"
  @steem_meta %{blockchain: :steem, type: :comment}

  def send(%{data: %{author: author, permlink: permlink}, metadata: @steem_meta}) do
    {:ok, comment} = Steemex.get_content(author, permlink)
    Endpoint.broadcast! @steem_events, {"new_comment", comment}
  end


end
