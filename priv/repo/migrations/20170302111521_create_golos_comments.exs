defmodule Glasnost.Repo.Migrations.CreatePosts do
  use Ecto.Migration

  def change do

  create_if_not_exists table(:posts, engine: :set) do
      add :id, :integer
      add :author, :string, []
      add :title, :string
      add :permlink, :string, []
      add :body, :string
      add :tags, {:array, :string}
      add :category, :string
      add :json_metadata, :map
      add :created, :string
    end
  end

end
