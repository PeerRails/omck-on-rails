require 'test_helper'

class KeysControllerTest < ActionController::TestCase
  test "should get make_key" do
    get :make_key
    assert_response :success
  end

  test "should get change_key" do
    get :change_key
    assert_response :success
  end

end
