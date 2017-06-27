defmodule Glasnost.Repo.Migrations.AddBodyHtmlToGolosComments do
  use Ecto.Migration

  def change do
    alter table(:golos_comments) do
      add :body_html, :type_is_ignored
    end
  end
end
