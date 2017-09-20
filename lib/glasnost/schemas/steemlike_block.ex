defmodule Glasnost.Steemlike.Block do
  require Logger
  alias Glasnost.Repo

  def update(event, blockchain: blockchain) do
    %{data: data, metadata: %{source: source}} = event
    {schema_mod, client_mod} = case blockchain do
      :steem -> {Glasnost.Steem.Block, Steemex}
      :golos -> {Glasnost.Golos.Block, Golos}
    end
    block = struct(schema_mod, Map.from_struct(event.data))
    Repo.insert!(block, on_conflict: :replace_all, conflict_target: [:height])
  end

  def add_timestamps(comment) do
    comment
    |> Map.put(:updated_at, NaiveDateTime.utc_now)
    |> Map.put(:inserted_at, NaiveDateTime.utc_now)
  end



end
