defmodule Glasnost.Schema do
  use Absinthe.Schema
  import_types Glasnost.Schema.Types

  query do
    field :steem_comments, list_of(:comment) do
      resolve fn _args, info -> Glasnost.CommentResolver.all(%{blockchain: :steem}, info) end
    end

    field :golos_comments, list_of(:comment) do
      resolve fn _args, info -> Glasnost.CommentResolver.all(%{blockchain: :golos}, info) end
    end
  end

end
