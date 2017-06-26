defmodule Glasnost.Steem.Comment do
  use Ecto.Schema
  import Ecto.Changeset
  alias Glasnost.Comment
  defdelegate filter_by(posts, filter, rules), to: Comment.Filters, as: :by

  schema "posts" do
    field :author, :string
    field :permlink, :string
    field :title, :string
    field :body, :string
    field :body_html, :string
    field :tags, {:array, :string}
    field :json_metadata, :map
    field :category, :string
    field :blockchain, :string
    field :created, :naive_datetime
    field :unix_epoch, :integer
  end

  def changeset(comment, params) do
    comment
    |> cast(params, [:id, :author, :title, :json_metadata, :permlink, :body, :tags, :category, :created, :blockchain, :body_html, :unix_epoch])
    |> unique_constraint(:id, name: :steem_comments_id_index)
  end

end
