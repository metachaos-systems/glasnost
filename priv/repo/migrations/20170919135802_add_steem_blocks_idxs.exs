defmodule Glasnost.Repo.Migrations.AddSteemBlocksIdxs do
  use Ecto.Migration

  def change do
    create unique_index("steem_blocks", [:height])
    create index("steem_blocks", [:timestamp])
  end
end
