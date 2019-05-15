require 'test_helper'

class CourseEvaluationQuestionnaireControllerTest < ActionController::TestCase
  test "should get new" do
    get :new
    assert_response :success
  end

  test "should get edit" do
    get :edit
    assert_response :success
  end

  test "should get show" do
    get :show
    assert_response :success
  end

  test "should get confirm" do
    get :confirm
    assert_response :success
  end

end
