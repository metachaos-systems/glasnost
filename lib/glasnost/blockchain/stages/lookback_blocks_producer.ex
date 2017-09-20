defmodule Glasnost.Stage.LookbackBlocks do
  use GenStage
  alias Glasnost.Repo
  require Logger
  alias Ecto.Adapters.SQL
  # @blocks_per_tick 100
  @tick_duration 30_000
  @lookback_max_blocks 201_600

  def start_link(args, options) do
    GenStage.start_link(__MODULE__, args, options)
  end

  def init(%Glasnost.AgentConfig{} = config) do
    Logger.info("LookbackBlocks producer is initializing...")
    {:ok, %{head_block_number: head_block}} = config.client.get_dynamic_global_properties

    config = config
      |> Map.put_new(:starting_block, head_block)
      |> Map.put_new(:current_block, head_block)
    Process.send_after(self(), :next_blocks, @tick_duration)
    {:producer, config, dispatcher: GenStage.BroadcastDispatcher, buffer_size: 100_000}
  end

  def handle_demand(demand, state) do
    {:noreply, [], state}
  end

  def handle_info(:next_blocks, state) do
    import Ecto.Query
    {:ok, %{head_block_number: head_block}} = state.client.get_dynamic_global_properties
    table = Atom.to_string(state.token) <> "_blocks"
    block_schema = Module.concat([state.schema, Block])
    q = ("""
    SELECT generate_series(
        #{head_block},
        #{min_block_to_start(head_block, @lookback_max_blocks)},
        -1)
    EXCEPT (
      SELECT height
      FROM #{table}
    )
    LIMIT 1000
    ;
    """)
    {:ok, %{rows: rows}} = SQL.query(Repo, q)
    tasks = for block_height <- List.flatten(rows) do
      Task.async(
        fn ->
          {:ok, block} = state.client.get_block(block_height)
          block
       end
      )
    end
    blocks = for {_, {:ok, block}} <- Task.yield_many(tasks, 300_000) do
      %{data: block, metadata: %{source: :resync, type: :block}}
    end
    Process.send_after(self(), :next_blocks, @tick_duration)
    Logger.info("Broadcasting missing #{length blocks} block events for #{Atom.to_string(state.token)}")
    {:noreply, blocks, state}
  end

  def min_block_to_start(current_height, blocks) when is_integer(blocks)  do
    delta = current_height - blocks
    if delta < 1, do: 1, else: delta
  end

  def handle_info(msg, state) do
    Logger.info("unexpected msg: #{inspect msg}")
  end
end
