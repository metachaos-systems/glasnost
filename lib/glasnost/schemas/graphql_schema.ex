defmodule Glasnost.Schema do
  use Absinthe.Schema
  import_types Glasnost.Schema.Types

  enum :order_by_type, values: [:created, :total_payout_value, :pending_payout_value]
  enum :sort_type, values: [:desc, :asc]

  query do
    field :comments, list_of(:comment) do
      arg :blockchain, non_null(:string)
      arg :author, :string
      arg :tag, :string
      arg :category, :string
      arg :is_post, :boolean
      arg :order_by, :order_by_type
      arg :sort, :sort_type
      resolve &Glasnost.CommentResolver.all/2
    end

    field :comment, type: :comment do
      arg :blockchain, non_null(:string)
      arg :author, non_null(:string)
      arg :permlink, non_null(:string)
      resolve &Glasnost.CommentResolver.find/2
    end

    field :block, type: :block do
      arg :blockchain, non_null(:string)
      arg :height, :integer
      arg :get_last, :boolean
      resolve &Glasnost.BlockResolver.find/2
    end

    field :statistics, type: :statistic do
      arg :blockchain, non_null(:string)
      resolve &Glasnost.StatisticsResolver.all/2
    end

  end

end
