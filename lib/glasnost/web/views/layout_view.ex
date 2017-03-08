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
        }
    }[key][lang]
  end

  def naive_image_chooser(key, lang) do
    %{"logo" => %{
      "ru" => "golos-logo.png",
      "en" => "steem-logo.png",
      }}[key][lang]
  end
end
