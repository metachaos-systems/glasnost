defmodule Glasnost.RuntimeConfig do
  use GenServer
  require Logger
  @process_name :runtime_config
  @mix_env Mix.env

  def start_link(args \\ %{}, options \\ []) do
     GenServer.start_link(__MODULE__, args, options)
  end

  def init(args) do
      if @mix_env === :dev, do: :timer.send_after(1_000, :update_config)
     args = Map.put_new(args, :config, %{})
     {:ok, args}
  end

  def handle_call({:update_config, url}, _from, state) do
    Logger.info("Starting config update...")
    {result, state} = case fetch_external_config(url) do
        {:ok, data} ->
          GenServer.cast(self(), :restart_orchestrator)
          {{:ok, data}, put_in(state, [:config], data)}
        {:error, reason } ->
          {{:error, reason}, state}
    end
    Logger.info("Finishing config update...")
    {:reply, result, state}
  end

  def handle_call(:get_config, _from, state), do: {:reply, state.config, state}

  def handle_call(:exists, _from, state), do: {:reply, state.config != %{}, state}

  def handle_cast(:restart_orchestrator, state) do
    spawn_link(fn ->
      :ok = Supervisor.terminate_child(Glasnost.Supervisor, Glasnost.Orchestrator.AuthorSyncSup)
      {:ok, _} = Supervisor.restart_child(Glasnost.Supervisor, Glasnost.Orchestrator.AuthorSyncSup)
    end)
    {:noreply, state}
  end

  def exists?, do: GenServer.call(@process_name, :exists)

  def get_cached_config(), do: GenServer.call(@process_name, :get_config)

  def update(url), do: GenServer.call(@process_name, {:update_config, url})

  def get(:author_account_names) do
    get_cached_config()
      |> Map.get(:authors)
      |> Enum.map(& &1.account_name)
  end

  def get(:default_post_image) do
    case get(:language) do
      "russian" -> "default_img_golos.jpg"
      "english" -> "default_img_steem.jpg"
    end
  end

  def get(key) when is_atom(key) do
     Map.get(get_cached_config(), key) || throw("#{key} is NOT present in the remote config")
  end

  def blog_author, do: get(:blog_author)

  def about_blog_permlink, do: get(:about_blog_permlink)

  def blockchain_client_mod(source_blockchain) do
    case source_blockchain do
      "golos" -> Golos
      "steem" -> Steemex
    end
  end

  def language do
    case get(:language) do
      "russian" -> "ru"
      "english" -> "en"
    end
  end

  def fetch_external_config(url) do
    case @mix_env do
      :dev ->
        config = File.read!("priv/glasnost-dev-config.json") |> Poison.Parser.parse!()
        {:ok, AtomicMap.convert(config, safe: false)}
      :test ->
        config = File.read!("priv/glasnost-test-config.json") |> Poison.Parser.parse!()
        {:ok, AtomicMap.convert(config, safe: false)}
      :prod ->
        with {:ok, %HTTPoison.Response{body: body}} <- HTTPoison.get(url),
          {:ok, config} <- Poison.Parser.parse(body)
        do
          {:ok, AtomicMap.convert(config, safe: false)}
        else
          {:error, reason} -> {:error, reason}
        end
    end
  end

end
