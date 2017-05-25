defmodule Glasnost.Post do
  use Ecto.Schema
  import Ecto.Changeset
  defdelegate filter_by(posts, filter, rules), to: Glasnost.Post.Filters, as: :by

  schema "posts" do
    field :author, :string
    field :permlink, :string
    field :title, :string
    field :body, :string
    field :tags, {:array, :string}
    field :json_metadata, :map
    field :category, :string
    field :blockchain, :string
    field :created, :naive_datetime
  end

  def changeset(comment, params) do
    comment
    |> cast(params, [:id, :author, :title, :json_metadata, :permlink, :body, :tags, :category, :created])
    |> unique_constraint(:id, name: :golos_comments_id_index)
  end

end
