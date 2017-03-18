defmodule Glasnost.Web.PageView do
  use Glasnost.Web, :view

  def format_tag(eng_tag, lang) do
    case lang do
      "ru" -> GenServer.call(GolosJS, {:detransliterate, eng_tag})
      "en" -> eng_tag
    end
  end
end
