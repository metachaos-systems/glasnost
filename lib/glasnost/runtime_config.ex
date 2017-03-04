defmodule RuntimeConfig do

  def blog_author do
    System.get_env("GOLOS_BLOG_AUTHOR") 
  end
end
