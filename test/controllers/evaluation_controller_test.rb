require 'test_helper'

class EvaluationControllerTest < ActionController::TestCase
  test "should get show" do
    get :coachee_news
    assert_response :success
  end

  test "should get prev" do
    get :prev
    assert_response :success
  end

  test "should get next" do
    get :next
    assert_response :success
  end

  test "should get send" do
    get :send
    assert_response :success
  end

end
