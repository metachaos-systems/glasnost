defmodule Glasnost.Repo.Migrations.AddBodyHtmlToSteemComments do
  use Ecto.Migration

  def change do
    alter table(:steem_comments) do
      add :body_html, :type_is_ignored
    end
  end
end
