defmodule Glasnost.Schema do
  use Absinthe.Schema
  import_types Blog.Schema.Types

  query do
    field :steem_comments, list_of(:comment) do
      resolve &Glasnost.CommentResolver.all/2
    end

    field :golos_comments, list_of(:comment) do
      resolve &Glasnost.CommentResolver.all/2
    end
  end

end
