require File.dirname(__FILE__) + '/../test_helper'
require 'rips_controller'

# Re-raise errors caught by the controller.
class RipsController; def rescue_action(e) raise e end; end

class RipsControllerTest < Test::Unit::TestCase
  fixtures :rips

  def setup
    @controller = RipsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  def test_should_get_index
    get :index
    assert_response :success
    assert assigns(:rips)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end
  
  def test_should_create_rip
    old_count = Rip.count
    post :create, :rip => { }
    assert_equal old_count+1, Rip.count
    
    assert_redirected_to rip_path(assigns(:rip))
  end

  def test_should_show_rip
    get :show, :id => 1
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => 1
    assert_response :success
  end
  
  def test_should_update_rip
    put :update, :id => 1, :rip => { }
    assert_redirected_to rip_path(assigns(:rip))
  end
  
  def test_should_destroy_rip
    old_count = Rip.count
    delete :destroy, :id => 1
    assert_equal old_count-1, Rip.count
    
    assert_redirected_to rips_path
  end
end
