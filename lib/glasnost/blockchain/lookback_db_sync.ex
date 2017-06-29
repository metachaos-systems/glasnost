defmodule Glasnost.Stage.LookbackBlocks do
  use GenStage
  alias Glasnost.Repo
  require Logger
  @blocks_per_tick 5

  def start_link(args, options) do
    GenStage.start_link(__MODULE__, args, options)
  end

  def init(%Glasnost.AgentConfig{} = config) do
    Logger.info("LookbackBlocks producer is initializing...")
    {:ok, %{head_block_number: head_block}} = config.client.get_dynamic_global_properties
    config = Map.put_new(config, :starting_block, head_block)
    config = Map.put_new(config, :current_block, head_block)
    Process.send_after(self(), :next_blocks, 5_000)
    {:producer, config, dispatcher: GenStage.BroadcastDispatcher, buffer_size: 100_000}
  end

  def handle_demand(demand, state) do
    {:noreply, [], state}
  end

  def handle_info(:next_blocks, state) do
    import Ecto.Query
    Logger.info("Starting to import blocks from #{state.current_block}")
    cur_block  = state.current_block
    tasks = for height <- cur_block..cur_block - @blocks_per_tick do
      Task.async(fn ->
        {:ok, block} = state.client.get_block(height)
        block
      end)
    end
    blocks = Task.yield_many(tasks, 10_000)
    blocks = for {_, {:ok, block}}  <- blocks do
      struct(Golos.Event, %{data: block, metadata: %{}})
    end
    Process.send_after(self(), :next_blocks, 3_000)
    state = put_in(state.current_block, state.current_block - @blocks_per_tick)
    {:noreply, blocks, state}
  end

end
