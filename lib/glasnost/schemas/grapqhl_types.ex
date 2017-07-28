defmodule Glasnost.Schema.Types do
  use Absinthe.Schema.Notation

  object :comment do
    field :id, :integer
    field :author, :string
    field :permlink, :string
    field :title, :string
    field :body, :string
    field :body_html, :string
    field :tags, {:array, :string}
    field :json_metadata, :map
    field :category, :string
    field :created, :naive_datetime
    field :total_payout_value, :float
    field :pending_payout_value, :float
  end

end
