defmodule Glasnost.Web.LayoutView do
  use Glasnost.Web, :view

  def naive_translate(key, lang) do
    %{
      "about" => %{
        "ru" => "О блоге",
        "en" => "About",
        } ,
        "about_steemlike_chain" => %{
        "ru" => "О Голосе",
        "en" => "About Steem",
        },
        "home" => %{
          "ru" => "Главная",
          "en" => "Home"
        },
        "head title" => %{
          "ru" => "Блог на блокчейне Голоса",
          "en" => "Steem blockchain blog"
        }
    }[key][lang]
  end

  def naive_image_chooser(key, lang) do
    %{"logo" => %{
      "ru" => "golos-logo.png",
      "en" => "steem-logo.png",
      }}[key][lang] || "eye.png"
  end

  def menu_placeholder do
    [
      %{item: "item 1", dropdown_items: [["link 1", "title 1"], ["link 2", "title 2"]]}
    ]
  end
end
