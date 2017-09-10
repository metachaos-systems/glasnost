defmodule Glasnost.Repo.Migrations.AddAuthorPermlinkToBothChainsUidx do
  use Ecto.Migration

  def change do
    create unique_index("golos_comments", [:author, :permlink])
    create unique_index("steem_comments", [:author, :permlink])
  end
end
