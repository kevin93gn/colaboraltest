require 'test_helper'

class QuestionnaireControllerTest < ActionController::TestCase
  test "should get new" do
    get :new
    assert_response :success
  end

  test "should get show" do
    get :coachee_news
    assert_response :success
  end

  test "should get test" do
    get :test
    assert_response :success
  end

end
