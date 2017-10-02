defmodule Glasnost.ResolverUtils do
  def select_schema(blockchain, :comment) when is_binary(blockchain) do
    case blockchain do
      "steem" -> Glasnost.Steem.Comment
      "golos" -> Glasnost.Golos.Comment
    end
  end

  def select_schema(blockchain, :block) when is_binary(blockchain) do
    case blockchain do
      "steem" -> Glasnost.Steem.Comment
      "golos" -> Glasnost.Golos.Comment
    end
  end
end
