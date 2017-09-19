defmodule Glasnost.Golos.Block do
    use Ecto.Schema
    import Ecto.Changeset
    import Ecto.Query
    alias Ecto.Adapters.SQL
    alias Ecto.Multi
    alias Glasnost.Repo

    @primary_key false

    schema "golos_blocks" do
      field :extensions, {:array, :map}
      field :previous, :string
      field :timestamp, :naive_datetime
      field :transaction_merkle_root, :string
      field :transactions, {:array, :map}
      field :witness, :string
      field :witness_signatures, {:array, :string}
      field :height, :integer, primary_key: true

      timestamps
    end

    def changeset(data, params \\ %{}) do
      allowed_params = [:previous, :timestamp, :transaction_merkle_root, :witness, :witness_signatures, :transactions, :height]
      data
      |> cast(params, allowed_params)
      |> unique_constraint(:height)
    end

end
