defmodule Glasnost.Golos.Comment do
  use Ecto.Schema
  import Ecto.Changeset
  alias Glasnost.Comment
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
    # field :unix_epoch, :integer
  end

  def changeset(comment, params) do
    comment
    |> cast(params, [:id, :author, :title, :json_metadata, :permlink, :body, :tags, :category, :created, :body_html])
    |> unique_constraint(:id, name: :golos_comments_id_index)
  end

  def get_data_and_update(author, permlink) do
    {:ok, comment} = Golos.get_content(author, permlink)
    stored_comment = Glasnost.Repo.get(__MODULE__, comment.id) || %__MODULE__{}
    changeset = changeset(stored_comment, comment)
    Glasnost.Repo.update(changeset)
  end

end
