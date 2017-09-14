defmodule Glasnost.Steemlike.Comment do
  require Logger
  alias Glasnost.Repo


  def get_data_and_update(event, blockchain: blockchain) do
    %{data: %{author: author, permlink: permlink}, metadata: %{source: source}} = event
    {schema_mod, client_mod} = case blockchain do
      :steem -> {Glasnost.Steem.Comment, Steemex}
      :golos -> {Glasnost.Golos.Comment, Golos}
    end
    existing_comment = Repo.get_by(schema_mod, author: author, permlink: permlink)
    should_be_updated = (source === :resync and is_nil(existing_comment)) or (existing_comment.updated_at < event.metadata.timestamp) or (source === :naive_realtime)
    if should_be_updated do
      {:ok, new_comment_data} = client_mod.get_content(author, permlink)
      if new_comment_data.id !== 0 do
        cleaned_comment_data = new_comment_data |> add_timestamps()
        c = struct(schema_mod, cleaned_comment_data)
        Glasnost.Repo.insert(c, on_conflict: :replace_all, conflict_target: [:author, :permlink])
      end
    end
  end

  def add_timestamps(comment) do
    comment
    |> Map.put(:updated_at, NaiveDateTime.utc_now)
    |> Map.put(:inserted_at, NaiveDateTime.utc_now)
  end

  def permitted_fields() do
    ~w(id author title json_metadata permlink body tags category created body_html total_payout_value pending_payout_value inserted_at updated_at)a
  end

end
