defmodule Glasnost.Schema do
  use Absinthe.Schema
  import_types Glasnost.Schema.Types

  query do
    field :comments, list_of(:comment) do
      resolve &Glasnost.CommentResolver.all/2
    end

    field :comment, type: :comment do
      arg :id, non_null(:id)
      resolve &Glasnost.CommentResolver.find/2
    end

  end

end
