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
    # field :unix_epoch, :integer
  end

  def changeset(comment, params) do
    comment
    |> cast(params, [:id, :author, :title, :json_metadata, :permlink, :body, :tags, :category, :created, :body_html])
    |> unique_constraint(:id, name: :golos_comments_id_index)
  end

  def get_data_and_update(author, permlink) do
    {:ok, new_comment_data} = Golos.get_content(author, permlink)
    new_comment_data = new_comment_data
      |> Glasnost.Steemlike.Comment.parse_json_metadata
      |> Glasnost.Steemlike.Comment.extract_put_tags
    result =
      case Glasnost.Repo.get(__MODULE__, new_comment_data.id) do
          nil  -> %__MODULE__{id: new_comment_data.id}
          comment -> comment
        end
        |> __MODULE__.changeset(new_comment_data)
        |> Glasnost.Repo.insert_or_update

    case result do
      {:ok, struct}       ->
        Logger.info("Inserted or update ok")
        # Inserted or updated with success
      {:error, changeset} ->
        Logger.error("Persistence failed...")
        Logger.error(changeset)
        # Something went wrong
    end
  end

end
