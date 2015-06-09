require 'test_helper'

class VideosControllerTest < ActionController::TestCase
  test "should get upload" do
    get :upload
    assert_response :success
  end

  test "should get move" do
    get :move
    assert_response :success
  end

  test "should get delete" do
    get :delete
    assert_response :success
  end

end
