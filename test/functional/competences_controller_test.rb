require 'test_helper'

class CompetencesControllerTest < ActionController::TestCase
  setup do
    @competence = competences(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:competences)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create competence" do
    assert_difference('Competence.count') do
      post :create, :competence => @competence.attributes
    end

    assert_redirected_to competence_path(assigns(:competence))
  end

  test "should show competence" do
    get :show, :id => @competence.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @competence.to_param
    assert_response :success
  end

  test "should update competence" do
    put :update, :id => @competence.to_param, :competence => @competence.attributes
    assert_redirected_to competence_path(assigns(:competence))
  end

  test "should destroy competence" do
    assert_difference('Competence.count', -1) do
      delete :destroy, :id => @competence.to_param
    end

    assert_redirected_to competences_path
  end
end
