defmodule Glasnost.Repo.Migrations.AddUniqIndexToGolosComments do
  use Ecto.Migration
  @disable_ddl_transaction true

  def change do
    create index(:golos_comments, [:id], concurrently: true)
  end
end
