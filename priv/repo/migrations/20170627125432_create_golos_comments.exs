defmodule Glasnost.Repo.Migrations.CreateGolosComments do
  use Ecto.Migration

  def change do
    create_if_not_exists table(:golos_comments) do
        add :author, :text
        add :title, :text
        add :permlink, :text
        add :body, :text
        add :body_html, :text
        add :tags, {:array, :text}
        add :category, :text
        add :json_metadata, :map
        add :created, :timestamp
        add :total_payout_value, :float
        add :pending_payout_value, :float

        timestamps()
      end
  end
end
