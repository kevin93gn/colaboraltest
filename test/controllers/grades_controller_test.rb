require 'test_helper'

class GradesControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should get edit" do
    get :edit
    assert_response :success
  end

  test "should get edit_grade" do
    get :edit_grade
    assert_response :success
  end

  test "should get delete_grade" do
    get :delete_grade
    assert_response :success
  end

end
