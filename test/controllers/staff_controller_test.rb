require 'test_helper'

class StaffControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :redirect
  end

end
