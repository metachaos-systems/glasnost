defmodule RuntimeConfig do

  def blog_author do
    get_cached_config()
    |> Map.get(:blog_author)
  end

  def source_blockchain do
    get_cached_config()
    |> Map.get(:source_blockchain)
  end

  def about_blog_url do
    get_cached_config()
    |> Map.get(:about_blog_url)
  end

  def blockchain_client_mod do
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
    ConCache.get_or_store(:config_cache, :data, fn() ->
      fetch_external_config()
    end)
  end

  def fetch_external_config do
    url = System.get_env("GLASNOST_CONFIG_URL") || throw("GLASNOST_CONFIG_URL is NOT configured")
    with {:ok, %HTTPoison.Response{body: body}} <- HTTPoison.get(url),
      {:ok, config} <- Poison.Parser.parse(body)
    do
      for {k,v} <- config, do: {String.to_atom(k),v},into: %{}
    end
  end
end
