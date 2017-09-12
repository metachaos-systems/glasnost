defmodule Glasnost.Schema do
  use Absinthe.Schema
  import_types Glasnost.Schema.Types

  query do
    field :comments, list_of(:comment) do
      arg :blockchain, non_null(:string)
      arg :author, :string
      arg :tag, :string
      arg :category, :string
      arg :is_post, :boolean
      resolve &Glasnost.CommentResolver.all/2
    end

    field :comment, type: :comment do
      arg :blockchain, non_null(:string)
      arg :author, non_null(:string)
      arg :permlink, non_null(:string)
      resolve &Glasnost.CommentResolver.find/2
    end

    field :statistics, type: :statistic do
      resolve &Glasnost.StatisticsResolver.all/2
    end

  end

end
