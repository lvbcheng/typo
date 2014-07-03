require 'spec_helper'

describe Admin::ContentController do
#  render_views

  shared_examples_for 'merge action' do

    it 'should allow merging of an article' do
      article1 = Factory.create(:article,
                               :created_at => Time.now - 1.day)
      article2 = Factory.create(:article,
                               :created_at => '2004-04-01 12:00:00')
      debugger
      post :merge, 'article' => article1, :params => {:merge_with => article2.id }
     end


    describe "publishing a published article with an autosaved draft" do
      before do
        @orig = Factory(:article)
        @draft = Factory(:article, :parent_id => @orig.id, :state => 'draft', :published => false)
        post(:new,
             :id => @orig.id,
             :article => {:id => @draft.id, :body => 'update'})
      end

      xit "updates the original" do
        assert_raises ActiveRecord::RecordNotFound do
          Article.find(@draft.id)
        end
      end

      xit "deletes the draft" do
        Article.find(@orig.id).body.should == 'update'
      end
    end

    describe "publishing a draft copy of a published article" do
      before do
        @orig = Factory(:article)
        @draft = Factory(:article, :parent_id => @orig.id, :state => 'draft', :published => false)
        post(:new,
             :id => @draft.id,
             :article => {:id => @draft.id, :body => 'update'})
      end

      xit "updates the original" do
        assert_raises ActiveRecord::RecordNotFound do
          Article.find(@draft.id)
        end
      end

      xit "deletes the draft" do
        Article.find(@orig.id).body.should == 'update'
      end
    end

    describe "saving a published article as draft" do
      before do
        @orig = Factory(:article)
        post(:new,
             :id => @orig.id,
             :article => {:title => @orig.title, :draft => 'draft',
               :body => 'update' })
      end

      xit "leaves the original published" do
        @orig.reload
        @orig.published.should == true
      end

      xit "leaves the original as is" do
        @orig.reload
        @orig.body.should_not == 'update'
      end

      xit "redirects to the index" do
        response.should redirect_to(:action => 'index')
      end

      xit "creates a draft" do
        draft = Article.child_of(@orig.id).first
        draft.parent_id.should == @orig.id
        draft.should_not be_published
      end
    end

    describe "with an unrelated draft in the database" do
      before do
        @draft = Factory(:article, :state => 'draft')
      end

      describe "saving new article as draft" do
        xit "leaves the original draft in existence" do
          post(
            :new,
            'article' => base_article({:draft => 'save as draft'}))
          assigns(:article).id.should_not == @draft.id
          Article.find(@draft.id).should_not be_nil
        end
      end
    end
  end

  shared_examples_for 'destroy action' do

    xit 'should_not destroy article by get' do
      lambda do
        art_id = @article.id
        assert_not_nil Article.find(art_id)

        get :destroy, 'id' => art_id
        response.should be_success
      end.should_not change(Article, :count)
    end

    xit 'should destroy article by post' do
      lambda do
        art_id = @article.id
        post :destroy, 'id' => art_id
        response.should redirect_to(:action => 'index')

        lambda{
          article = Article.find(art_id)
        }.should raise_error(ActiveRecord::RecordNotFound)
      end.should change(Article, :count).by(-1)
    end

  end


  describe 'with admin connection' do

    before do
      Factory(:blog)
      #TODO delete this after remove fixture
      Profile.delete_all
      @user = Factory(:user, :text_filter => Factory(:markdown), :profile => Factory(:profile_admin, :label => Profile::ADMIN))
      @user.editor = 'simple'
      @user.save
      @article = Factory(:article)
      request.session = { :user => @user.id }
    end

#    it_should_behave_like 'index action'
#    it_should_behave_like 'new action'
    it_should_behave_like 'merge action'    
#    it_should_behave_like 'destroy action'
#    it_should_behave_like 'autosave action'

    describe 'edit action' do

      xit 'should edit article' do
        get :edit, 'id' => @article.id
        response.should render_template('new')
        assigns(:article).should_not be_nil
        assigns(:article).should be_valid
        response.should contain(/body/)
        response.should contain(/extended content/)
      end

      xit 'should update article by edit action' do
        begin
          ActionMailer::Base.perform_deliveries = true
          emails = ActionMailer::Base.deliveries
          emails.clear

          art_id = @article.id

          body = "another *textile* test"
          post :edit, 'id' => art_id, 'article' => {:body => body, :text_filter => 'textile'}
          assert_response :redirect, :action => 'show', :id => art_id

          article = @article.reload
          article.text_filter.name.should == "textile"
          body.should == article.body

          emails.size.should == 0
        ensure
          ActionMailer::Base.perform_deliveries = false
        end
      end

      xit 'should allow updating body_and_extended' do
        article = @article
        post :edit, 'id' => article.id, 'article' => {
          'body_and_extended' => 'foo<!--more-->bar<!--more-->baz'
        }
        assert_response :redirect
        article.reload
        article.body.should == 'foo'
        article.extended.should == 'bar<!--more-->baz'
      end

      xit 'should delete draft about this article if update' do
        article = @article
        draft = Article.create!(article.attributes.merge(:state => 'draft', :parent_id => article.id, :guid => nil))
        lambda do
          post :edit, 'id' => article.id, 'article' => { 'title' => 'new'}
        end.should change(Article, :count).by(-1)
        Article.should_not be_exists({:id => draft.id})
      end

      xit 'should delete all draft about this article if update not happen but why not' do
        article = @article
        draft = Article.create!(article.attributes.merge(:state => 'draft', :parent_id => article.id, :guid => nil))
        draft_2 = Article.create!(article.attributes.merge(:state => 'draft', :parent_id => article.id, :guid => nil))
        lambda do
          post :edit, 'id' => article.id, 'article' => { 'title' => 'new'}
        end.should change(Article, :count).by(-2)
        Article.should_not be_exists({:id => draft.id})
        Article.should_not be_exists({:id => draft_2.id})
      end
    end

    describe 'resource_add action' do

      xit 'should add resource' do
        art_id = @article.id
        resource = Factory(:resource)
        get :resource_add, :id => art_id, :resource_id => resource.id

        response.should render_template('_show_resources')
        assigns(:article).should be_valid
        assigns(:resource).should be_valid
        assert Article.find(art_id).resources.include?(resource)
        assert_not_nil assigns(:article)
        assert_not_nil assigns(:resource)
        assert_not_nil assigns(:resources)
      end

    end

    describe 'resource_remove action' do

      xit 'should remove resource' do
        art_id = @article.id
        resource = Factory(:resource)
        get :resource_remove, :id => art_id, :resource_id => resource.id

        response.should render_template('_show_resources')
        assert assigns(:article).valid?
        assert assigns(:resource).valid?
        assert !Article.find(art_id).resources.include?(resource)
        assert_not_nil assigns(:article)
        assert_not_nil assigns(:resource)
        assert_not_nil assigns(:resources)
      end
    end

    describe 'auto_complete_for_article_keywords action' do
      before do
        Factory(:tag, :name => 'foo', :articles => [Factory(:article)])
        Factory(:tag, :name => 'bazz', :articles => [Factory(:article)])
        Factory(:tag, :name => 'bar', :articles => [Factory(:article)])
      end

      xit 'should return foo for keywords fo' do
        get :auto_complete_for_article_keywords, :article => {:keywords => 'fo'}
        response.should be_success
        response.body.should == '<ul class="unstyled" id="autocomplete"><li>foo</li></ul>'
      end

      xit 'should return nothing for hello' do
        get :auto_complete_for_article_keywords, :article => {:keywords => 'hello'}
        response.should be_success
        response.body.should == '<ul class="unstyled" id="autocomplete"></ul>'
      end

      xit 'should return bar and bazz for ba keyword' do
        get :auto_complete_for_article_keywords, :article => {:keywords => 'ba'}
        response.should be_success
        response.body.should == '<ul class="unstyled" id="autocomplete"><li>bar</li><li>bazz</li></ul>'
      end
    end

  end

  describe 'with publisher connection' do

    before :each do
      Factory(:blog)
      @user = Factory(:user, :text_filter => Factory(:markdown), :profile => Factory(:profile_publisher))
      @article = Factory(:article, :user => @user)
      request.session = {:user => @user.id}
    end

#    it_should_behave_like 'index action'
#    it_should_behave_like 'new action'
    it should_behave_like 'merge action'
    it_should_behave_like 'destroy action'

    describe 'edit action' do

      xit "should redirect if edit article doesn't his" do
        get :edit, :id => Factory(:article, :user => Factory(:user, :login => 'another_user')).id
        response.should redirect_to(:action => 'index')
      end

      xit 'should edit article' do
        get :edit, 'id' => @article.id
        response.should render_template('new')
        assigns(:article).should_not be_nil
        assigns(:article).should be_valid
      end

      xit 'should update article by edit action' do
        begin
          ActionMailer::Base.perform_deliveries = true
          emails = ActionMailer::Base.deliveries
          emails.clear

          art_id = @article.id

          body = "another *textile* test"
          post :edit, 'id' => art_id, 'article' => {:body => body, :text_filter => 'textile'}
          response.should redirect_to(:action => 'index')

          article = @article.reload
          article.text_filter.name.should == "textile"
          body.should == article.body

          emails.size.should == 0
        ensure
          ActionMailer::Base.perform_deliveries = false
        end
      end
    end
  end
end
