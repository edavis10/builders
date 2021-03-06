require 'test_helper'
 
class UsersControllerTest < ActionController::TestCase
  context 'GET to index' do
    setup { get :index }
    
    should_respond_with :success
    should_assign_to :users
  end
 
  context 'GET to new' do
    setup { get :new }
 
    should_respond_with :success
    should_render_template :new
    should_assign_to :user
  end
 
  context 'POST to create' do
    context "with valid attributes" do
      setup do
        post :create, :user => Factory.attributes_for(:user)
        @user = User.last
      end
    
      should_change 'User.count', :by => 1
      should_set_the_flash_to /created/i
      should_redirect_to('user show') {user_path(@user)}
      should_filter_params :password, :password_confirmation
    end
    
    context "with invalid attributes" do
      setup do
         post :create, :user => Factory.attributes_for(:user, :password => 'bad')
      end

      should_not_change 'User.count'
      should_not_set_the_flash
      should_render_template :new
      should_filter_params :password, :password_confirmation
    end       
  end
 
  context 'GET to show' do
    setup do
      @user = Factory(:user)
      get :show, :id => @user.to_param
    end
    
    should_respond_with :success
    should_render_template :show
    should_assign_to :user
  end
 
  context 'GET to edit' do
    setup do
      @user = Factory(:user)
      get :edit, :id => @user.to_param
    end
    
    should_respond_with :success
    should_render_template :edit
    should_assign_to :user
  end
 
  context 'PUT to update' do
    setup do
      @user = Factory(:user)
      put :update, :id => @user.to_param, :user => Factory.attributes_for(:user)
    end
    
    should_set_the_flash_to /updated/i
    should_redirect_to('user show') {user_path(@user)}
  end
  
  context 'given a user exists' do
    setup { @user = Factory(:user) }

    context 'DELETE to destroy' do
      setup { delete :destroy, :id => @user.to_param }
      
      should_change 'User.count', :from => 1, :to => 0
      should_set_the_flash_to /deleted/i
      should_redirect_to('user index') { users_path }
    end
  end  
end