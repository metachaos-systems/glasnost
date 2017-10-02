defmodule Glasnost.Schema.Types do
  use Absinthe.Schema.Notation

  scalar :naive_datetime, description: "ISOz time" do
    parse &NaiveDateTime.from_iso8601!/1
    serialize &NaiveDateTime.to_string/1
  end

  scalar :json, description: "generic JS object" do
    parse &Poison.Parser.parse!/1
    serialize & &1
  end

  object :comment do
    field :id, :integer
    field :author, :string
    field :permlink, :string
    field :parent_author, :string
    field :parent_permlink, :string
    field :title, :string
    field :body, :string
    field :body_html, :string
    field :tags, %Absinthe.Type.List{of_type: :string}
    field :category, :string
    field :created, :naive_datetime
    field :total_payout_value, :float
    field :pending_payout_value, :float
  end

  object :block do
    field :previous, :string
    field :timestamp, :naive_datetime
    field :transaction_merkle_root, :string
    field :transactions, %Absinthe.Type.List{of_type: :json}
    field :witness, :string
    # field :witness_signatures, {:array, :string}
    field :height, :integer
  end

  object :statistic do
    field :count, :integer
  end

end
