require 'test_helper'

class RailsGirlsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @rails_girl = rails_girls(:one)
  end

  test "should get index" do
    get rails_girls_url
    assert_response :success
  end

  test "should get new" do
    get new_rails_girl_url
    assert_response :success
  end

  test "should create rails_girl" do
    assert_difference('RailsGirl.count') do
      post rails_girls_url, params: { rails_girl: { message: 'A message', name: 'Jenny' } }
    end

    assert_redirected_to root_path
  end

  test "should show rails_girl" do
    get rails_girl_url(@rails_girl)
    assert_response :success
  end

  test "should get edit" do
    get edit_rails_girl_url(@rails_girl)
    assert_response :success
  end

  test "should update rails_girl" do
    patch rails_girl_url(@rails_girl), params: { rails_girl: { message: 'A new message', name: @rails_girl.name } }
    assert_redirected_to rails_girl_url(@rails_girl)
  end

  test "should destroy rails_girl" do
    assert_difference('RailsGirl.count', -1) do
      delete rails_girl_url(@rails_girl)
    end

    assert_redirected_to rails_girls_url
  end
end
