defmodule Glasnost.Post do
  use Ecto.Schema
  import Ecto.Changeset

  schema "posts" do
    field :author, :string
    field :permlink, :string
    field :title, :string
    field :body, :string
    field :tags, {:array, :string}
    field :json_metadata, :map
    field :category, :string
    field :created, Ecto.DateTime
  end

  def changeset(comment, params) do
    comment
    |> cast(params, [:id, :author, :title, :json_metadata, :permlink, :body, :tags, :category, :created])
    |> unique_constraint(:id, name: :golos_comments_id_index)
  end
end
