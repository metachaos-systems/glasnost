defmodule Glasnost.Repo.Migrations.AddUniqIndexToSteemComments do
  use Ecto.Migration
  @disable_ddl_transaction true

  def change do
    create index(:steem_comments, [:id], concurrently: true)
  end
end
