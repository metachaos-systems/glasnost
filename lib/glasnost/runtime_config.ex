defmodule RuntimeConfig do

  def blog_author do
    System.get_env("GOLOS_BLOG_AUTHOR")
  end

  def source_blockchain do
    System.get_env("GLASNOST_SOURCE_BLOCKCHAIN")
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
end
