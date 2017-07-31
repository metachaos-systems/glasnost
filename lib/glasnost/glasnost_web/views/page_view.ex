defmodule GlasnostWeb.PageView do
  use GlasnostWeb, :view

  def format_tag(eng_tag, blockchain) do
    case blockchain do
      "golos" -> GenServer.call(GolosJS, {:detransliterate, eng_tag})
      "steem" -> eng_tag
    end
  end

  def format_excerpt(post) do
    post.body_html
    |> Floki.text(sep: " ")
    |> String.slice(0..255)
  end

  def generate_pagination_list(current_page) do
    case current_page do
      x when x <= 2 -> 1..5
      x -> x-2..x+2
    end
    |> Enum.with_index(1)
  end

  def format_created(post) do
    hd(String.split(NaiveDateTime.to_string(post.created)))
  end

  def generate_img_for_post(conn, post) do
    #  metadata images property varies from post to post: BOTH "image" and "images" are seen in the wild
    #  FIXME: image property is non-standard and should be removed at some time in the future
    hd(post.json_metadata["image"] || post.json_metadata["images"] || ["/images/"<> conn.assigns.default_post_image])
  end
end
