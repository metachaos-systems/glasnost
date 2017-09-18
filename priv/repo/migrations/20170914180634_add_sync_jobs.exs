defmodule Glasnost.Repo.Migrations.AddSyncJobs do
  use Ecto.Migration

  def change do
    create_if_not_exists table(:sync_jobs) do
      add :name, :text
      add :params, :map
      add :state, :map
    end
  end
end
