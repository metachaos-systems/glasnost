defmodule Glasnost.ResolverUtils do
  def select_schema(blockchain) when is_binary(blockchain) do
    case blockchain do
      "steem" -> Glasnost.Steem.Comment
      "golos" -> Glasnost.Golos.Comment
    end
  end
end
