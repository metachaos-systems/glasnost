defmodule Glasnost.Stage.LookbackBlocks do
  use GenStage
  alias Glasnost.Repo

  def start_link(args, options) do
    GenStage.start_link(__MODULE__, args, options)
  end

  def init(config) do
    {:ok, %{head_block_number: head_block}} = config.client.get_dynamic_global_properties
    config = Map.put_new(config, :starting_block, head_block)
    Process.send_after(self(), :next_blocks, 5_000)
    {:producer, config, dispatcher: GenStage.BroadcastDispatcher, buffer_size: 100_000}
  end

  def handle_demand(demand, state) do
    {:noreply, [], state}
  end

  def handle_info(:next_blocks, state) do
    import Ecto.Query
    tasks = for height <- state.current_starting_block..state.current_starting_block - 100 do
      Task.async(fn ->
        {:ok, block} = state.client_mod.get_block(height)
      end)
    end
    blocks = Task.yield_many(tasks, 30_000)
    Process.send_after(self(), :next_blocks, 3_000)
    {:noreply, blocks, state}
  end

end
