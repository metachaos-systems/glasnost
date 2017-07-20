defmodule Glasnost.Steemlike.Comment do

  def get_data_and_update(author, permlink) do
    {:ok, new_comment_data} = Golos.get_content(author, permlink)
    new_comment_data = new_comment_data
      |> Glasnost.Steemlike.Comment.parse_json_metadata
      |> Glasnost.Steemlike.Comment.extract_put_tags
    result =
      case Glasnost.Repo.get(__MODULE__, new_comment_data.id) do
          nil  -> %__MODULE__{id: new_comment_data.id}
          comment -> comment
        end
        |> __MODULE__.changeset(new_comment_data)
        |> Glasnost.Repo.insert_or_update

    case result do
      {:ok, struct}       ->
        Logger.info("Inserted or update ok")
        # Inserted or updated with success
      {:error, changeset} ->
        Logger.error("Persistence failed...")
        Logger.error(changeset)
        # Something went wrong
    end
  end
  
  def parse_json_metadata(comment) do
     result = case Poison.Parser.parse(comment.json_metadata) do
       {:ok, map} -> map
       {:error, :invalid} -> %{}
     end
     put_in(comment.json_metadata, result)
  end

  def extract_put_tags(comment) do
     Map.put(comment, :tags, comment.json_metadata["tags"])
  end

end
