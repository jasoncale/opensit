require 'test_helper'

class SitsControllerTest < ActionController::TestCase
  setup do
    @sit = sits(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:sits)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create sit" do
    assert_difference('Sit.count') do
      post :create, sit: { allow_comments: @sit.allow_comments, content: @sit.content, title: @sit.title, user_id: @sit.user_id }
    end

    assert_redirected_to sit_path(assigns(:sit))
  end

  test "should show sit" do
    get :show, id: @sit
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @sit
    assert_response :success
  end

  test "should update sit" do
    put :update, id: @sit, sit: { allow_comments: @sit.allow_comments, content: @sit.content, title: @sit.title, user_id: @sit.user_id }
    assert_redirected_to sit_path(assigns(:sit))
  end

  test "should destroy sit" do
    assert_difference('Sit.count', -1) do
      delete :destroy, id: @sit
    end

    assert_redirected_to sits_path
  end
end
