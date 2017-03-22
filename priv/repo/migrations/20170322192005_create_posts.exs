defmodule Glasnost.Repo.Migrations.CreatePosts do
  use Ecto.Migration

  def up do
    create_if_not_exists table(:posts, engine: :set) do
        add :id, :type_is_ignored_by_ecto_mnesia
        add :author, :type_is_ignored_by_ecto_mnesia
        add :title, :type_is_ignored_by_ecto_mnesia
        add :permlink, :type_is_ignored_by_ecto_mnesia
        add :body, :type_is_ignored_by_ecto_mnesia
        add :tags, :type_is_ignored_by_ecto_mnesia
        add :category, :type_is_ignored_by_ecto_mnesia
        add :json_metadata, :type_is_ignored_by_ecto_mnesia
        add :created, :type_is_ignored_by_ecto_mnesia
      end
  end
end
