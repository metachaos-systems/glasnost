defmodule Glasnost.Repo.Migrations.AddBodyHtmlToPosts do
  use Ecto.Migration

  def change do
    alter table(:posts) do
      add :body_html, :type_is_ignored
    end
  end
end
