require 'test_helper'

class ModuleItemsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
  end

  test "should get show" do
    get :coachee_news
    assert_response :success
  end

  test "should get comments" do
    get :comments
    assert_response :success
  end

end
