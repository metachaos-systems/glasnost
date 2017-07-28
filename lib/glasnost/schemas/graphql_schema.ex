defmodule Glasnost.Schema do
  use Absinthe.Schema
  import_types Glasnost.Schema.Types

  query do
    field :comments, list_of(:comment) do
      resolve &Glasnost.CommentResolver.all/2
    end


  end

end
