defmodule RuntimeConfig do

  def blog_author do
    System.get_env("GLASNOST_BLOG_AUTHOR") || throw("GLASNOST_BLOG_AUTHOR is NOT configured")
  end

  def source_blockchain do
    System.get_env("GLASNOST_SOURCE_BLOCKCHAIN") || throw("GLASNOST_SOURCE_BLOCKCHAIN is NOT configured")
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

  def fetch_external_config do
    url = System.get_env("GLASNOST_CONFIG_URL") || throw("GLASNOST_CONFIG_URL is NOT configured")
    with {:ok, %HTTPoison.Response{body: body}} <- HTTPoison.get(url),
      {:ok, config} <- Poison.Parser.parse(body)
    do
      config
    end
  end
end
