defmodule Glasnost.Repo.Migrations.AddFieldsToGolosComments do
  use Ecto.Migration

  def change do
    alter table(:steem_comments) do
      add :parent_author, :text
      add :parent_permlink, :text
    end
  end
end
