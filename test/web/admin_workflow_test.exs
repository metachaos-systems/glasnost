defmodule AdminWorkflowTest do
  use ExUnit.Case
  use Hound.Helpers

  hound_session()

  test "the truth", meta do
    navigate_to("http://localhost:4000")

    password_element = find_element(:id, "password")
    IO.inspect(password_element)

    assert page_title() == "Thank you"
  end

end
