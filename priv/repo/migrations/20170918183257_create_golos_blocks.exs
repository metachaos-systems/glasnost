defmodule Glasnost.Repo.Migrations.CreateGolosBlocks do
  use Ecto.Migration

  def change do
    execute("
      create table golos_blocks
        (
        	extensions jsonb,
        	previous text,
        	timestamp timestamp,
        	transaction_merkle_root text,
        	transactions jsonb,
        	witness text,
        	witness_signatures text[],
        	height integer,
        	inserted_at timestamp not null,
        	updated_at timestamp not null
        )
        ;
    ")
  end

end
