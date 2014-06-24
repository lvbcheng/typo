require 'spec_helper'

describe Admin::CategoriesController do
  render_views

  before(:each) do
    Factory(:blog)
    #TODO Delete after removing fixtures
    Profile.delete_all
    henri = Factory(:user, :login => 'henri', :profile => Factory(:profile_admin, :label => Profile::ADMIN))
    request.session = { :user => henri.id }
  end

  it "test_index" do
    get :index
    assert_response :redirect, :action => 'index'
  end

  describe "test_new with GET" do
    before(:each) do
      get :new, :id => nil
    end

    it 'should render template new' do
      assert_template 'new'
    end

    it 'should have a valid categories array' do
      assigns(:categories).should_not be_nil
      assigns(:category).should_not be_nil
    end
  end

  describe "test_edit" do
    before(:each) do
      get :edit, :id => Factory(:category).id
    end

    it 'should render template new' do
      assert_template 'new'
      assert_tag :tag => "table",
        :attributes => { :id => "category_container" }
    end

    it 'should have valid category' do
      assigns(:category).should_not be_nil
      assert assigns(:category).valid?
      assigns(:categories).should_not be_nil
    end
  end

  it "test_update" do
    the_category = Factory(:category)
    assert_not_nil Category.find(the_category.id)
    post :edit, :id => the_category.id, :category => {name: 'hello'}
    Category.find(the_category.id).name.should eq('hello')
    flash[:notice].should eq('Category was successfully saved.')
    assert_response :redirect, :action => 'new'
  end

#  it "test_failed_update" do
#    the_category  = Factory(:category)
#    the_category2 = Factory(:category)
#    debugger
#    assert_not_nil Category.find(the_category.id)
#    post :edit, :id => the_category.id, :category => {name: the_category2.name}
#    flash[:error].should eq('Category could not be saved.')
#    assert_response :redirect, :action => 'new'
#  end

  describe "test_destroy with GET" do
    before(:each) do
      test_id = Factory(:category).id
      assert_not_nil Category.find(test_id)
      get :destroy, :id => test_id
    end

    it 'should render destroy template' do
      assert_response :success
      assert_template 'destroy'
    end
  end

  it "test_destroy with POST" do
    test_id = Factory(:category).id
    assert_not_nil Category.find(test_id)
    get :destroy, :id => test_id

    post :destroy, :id => test_id
    assert_response :redirect, :action => 'new'

    assert_raise(ActiveRecord::RecordNotFound) { Category.find(test_id) }
  end

end
