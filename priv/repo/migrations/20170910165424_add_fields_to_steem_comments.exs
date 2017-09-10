defmodule Glasnost.Repo.Migrations.AddFieldsToSteemComments do
  use Ecto.Migration

  def change do
    alter table(:golos_comments) do
      add :parent_author, :text
      add :parent_permlink, :text
    end
  end
end
