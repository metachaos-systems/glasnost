defmodule AdminWorkflowTest do
  use ExUnit.Case
  use Hound.Helpers

  hound_session()

  test "onboarding flow completes successfully", meta do
    navigate_to("/admin")
    assert page_title() == "Thank you"
  end

end
