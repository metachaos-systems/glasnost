defmodule RuntimeConfig do
  @mix_env Mix.env

  def get(:author_account_names) do
    get_cached_config()
      |> Map.get(:authors)
      |> Enum.map(& &1.account_name)
  end

  def get(key) when is_atom(key) do
     Map.get(get_cached_config(), key) || throw("#{key} is NOT present in the remote config")
  end

  def blog_author do
    get(:blog_author)
  end

  def source_blockchain do
    get(:source_blockchain)
  end

  def about_blog_permlink do
    get(:about_blog_permlink)
  end

  def blockchain_client_mod() do
    case String.downcase(source_blockchain()) do
      "golos" -> Golos
      "steem" -> Steemex
    end
  end

  def language do
    case source_blockchain() do
      "golos" -> "ru"
      "steem" -> "en"
    end
  end

  def get_cached_config do
    case @mix_env do
      :dev ->
        config = File.read!("priv/glasnost-runtime-config.json") |> Poison.Parser.parse!()
        AtomicMap.convert(config, safe: true)
      :prod ->
        ConCache.get_or_store(:config_cache, :data, fn() ->
          fetch_external_config()
        end)
    end
  end

  def fetch_external_config do
    url = System.get_env("GLASNOST_CONFIG_URL") || throw("GLASNOST_CONFIG_URL is NOT configured")
    with {:ok, %HTTPoison.Response{body: body}} <- HTTPoison.get(url),
      {:ok, config} <- Poison.Parser.parse(body)
    do
        AtomicMap.convert(config, safe: true)
    end
  end
end
