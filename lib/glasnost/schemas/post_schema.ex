defmodule Glasnost.Post do
  use Ecto.Schema
  import Ecto.Changeset
  defdelegate filter_by(posts, filter, rules), to: Glasnost.Comment.Filters, as: :by

  schema "posts" do
    field :author, :string
    field :permlink, :string
    field :title, :string
    field :body, :string
    field :body_html, :string
    field :tags, {:array, :string}
    field :json_metadata, :map
    field :category, :string
    field :blockchain, :string
    field :created, :naive_datetime
    field :unix_epoch, :integer
  end

  def changeset(comment, params) do
    comment
    |> cast(params, [:id, :author, :title, :json_metadata, :permlink, :body, :tags, :category, :created, :blockchain, :body_html, :unix_epoch])
    |> unique_constraint(:id, name: :golos_comments_id_index)
  end

  def prepare_post_for_publishing(post) do
    find_img_urls_and_replace_with_tags(post)
  end

  def find_img_urls_and_replace_with_tags(post) do
    {_, html, _} = Earmark.as_html(post["body"], %Earmark.Options{gfm: false})
    text = Floki.text(html, sep: " ")
    url_regex = ~r/(https?:\/\/)?([\da-z\.-]+)\.([a-z\.]{2,6})([\/\w \.-]*)*\/?/
    img_links = for word <- String.split(text, [" ", "\n"]) do
       cond do
         String.match?(word, url_regex) and String.match?(word, ~r/(\.png|\.jpg|\.gif)/) ->
           Floki.text(word)
         true -> nil
       end
    end
    img_links = Enum.filter(img_links, & &1) |> Enum.uniq
    html = Enum.reduce(img_links, html, fn link, html ->
      String.replace(html, link, ~s(<img src="#{link}""></img>))
    end)
    put_in(post, ["body_html"], html)
  end
end
