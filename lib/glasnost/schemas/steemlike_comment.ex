defmodule Glasnost.Steemlike.Comment do

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
