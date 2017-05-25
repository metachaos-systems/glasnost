defmodule Glasnost.Repo.Migrations.AddUnixEpochToPosts do
  use Ecto.Migration

  def change do
    alter table(:posts) do
      add :unix_epoch, :type_is_ignored
    end
  end
end
