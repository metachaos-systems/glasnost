defmodule Glasnost.Repo.Migrations.AddBlockchainToPosts do
  use Ecto.Migration

  def change do
    alter table(:posts) do
      add :blockchain, :type_is_ignored
    end
  end
end
