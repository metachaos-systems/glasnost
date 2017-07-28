defmodule Glasnost.Schema.Types do
  use Absinthe.Schema.Notation

  scalar :naive_datetime, description: "ISOz time" do
    parse &NaiveDateTime.to_string/1
    serialize &NaiveDateTime.from_iso8601!/2
  end

  object :comment do
    field :id, :integer
    field :author, :string
    field :permlink, :string
    field :title, :string
    field :body, :string
    field :body_html, :string
    field :tags, %Absinthe.Type.List{of_type: :string}
    field :category, :string
    field :created, :naive_datetime
    field :total_payout_value, :float
    field :pending_payout_value, :float
  end

end
