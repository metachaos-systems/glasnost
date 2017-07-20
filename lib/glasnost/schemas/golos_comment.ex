defmodule Glasnost.Golos.Comment do
  use Ecto.Schema
  import Ecto.Changeset
  alias Glasnost.Comment
  require Logger
  defdelegate filter_by(posts, filter, rules), to: Comment.Filters, as: :by

  schema "golos_comments" do
    field :author, :string
    field :permlink, :string
    field :title, :string
    field :body, :string
    field :body_html, :string
    field :tags, {:array, :string}
    field :json_metadata, :map
    field :category, :string
    field :created, :naive_datetime
    
    timestamps()
  end

  def changeset(comment, params) do
    comment
    |> cast(params, [:id, :author, :title, :json_metadata, :permlink, :body, :tags, :category, :created, :body_html, :inserted_at, :updated_at])
    |> unique_constraint(:id, name: :golos_comments_id_index)
  end

  def get_data_and_update(author, comment) do
    Glasnost.Steemlike.Comment.get_data_and_update(author, comment, blockchain: :golos)
  end
end
