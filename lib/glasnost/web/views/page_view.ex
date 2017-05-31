defmodule Glasnost.Web.PageView do
  use Glasnost.Web, :view

  def format_tag(eng_tag, blockchain) do
    case blockchain do
      "golos" -> GenServer.call(GolosJS, {:detransliterate, eng_tag})
      "steem" -> eng_tag
    end
  end


  def generate_pagination_list(current_page) do
    case current_page do
      x when x <= 2 -> 1..5
      x -> x-2..x+2
    end
    |> Enum.with_index(1)
  end
end
