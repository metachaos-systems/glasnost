defmodule Glasnost.Steemlike.Comment do
  require Logger
  alias Glasnost.Repo

  def get_data_and_update(author, permlink, blockchain: blockchain) do
    {schema_mod, client_mod} = case blockchain do
      :steem -> {Glasnost.Steem.Comment, Steemex}
      :golos -> {Glasnost.Golos.Comment, Golos}
    end
    existing_comment = Repo.get_by(schema_mod, author: author, permlink: permlink)
    unless existing_comment && existing_comment.updated_at > NaiveDateTime.utc_now 
    {:ok, new_comment_data} = client_mod.get_content(author, permlink)
    unless new_comment_data.id === 0 do
      cleaned_comment_data = new_comment_data |> add_timestamps()
      result =
        case Glasnost.Repo.get(schema_mod, cleaned_comment_data.id) do
            nil  -> struct(schema_mod, %{id: cleaned_comment_data.id})
            comment -> comment
          end
          |> schema_mod.changeset(cleaned_comment_data)
          |> Glasnost.Repo.insert_or_update

      case result do
        {:ok, struct}       ->
          :noop
        {:error, changeset} ->
          Logger.error("Persistence failed:")
          Logger.error(inspect changeset)
      end
    end
  end

  def add_timestamps(comment) do
    comment
    |> Map.put(:updated_at, NaiveDateTime.utc_now)
    |> Map.put(:inserted_at, NaiveDateTime.utc_now)
  end

  def permitted_fields() do
    ~w(id author title json_metadata permlink body tags category created body_html total_payout_value pending_payout_value inserted_at updated_at)a
  end

end
