defmodule Glasnost.Repo.Migrations.AddGolosBlocksIdxs do
  use Ecto.Migration

  def change do
    create unique_index("golos_blocks", [:height])
    create index("golos_blocks", [:timestamp])
  end
end
