defmodule Glasnost.CommentResolver do
  alias Glasnost.Repo

  def all(%{blockchain: blockchain}, _info) do
    schema = case blockchain do
      :steem -> Glasnost.Steem.Commment
      :golos -> Glasnost.Golos.Comment
    end
    {:ok, Repo.all(schema)}
  end

  def find(%{blockchain: blockchain, author: a, permlink: p}, _info) do
    schema = case blockchain do
      :steem -> Glasnost.Steem.Commment
      :golos -> Glasnost.Golos.Comment
    end
    {:ok, Repo.find(schema, author: a, permlink: p)}
  end
end
