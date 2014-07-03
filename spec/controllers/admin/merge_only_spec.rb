require 'spec_helper'

describe Admin::ContentController do
    before do
      Factory(:blog)
      #TODO delete this after remove fixture
      Profile.delete_all
      @user = Factory(:user, :text_filter => Factory(:markdown), :profile => Factory(:profile_admin, :label => Profile::ADMIN))
      @user.editor = 'simple'
      @user.save
      request.session = { :user => @user.id }
      @article1 = Factory.create(:article,
                                 :created_at => Time.now - 1.day)
      @article2 = Factory.create(:article,
                                 :created_at => '2004-04-01 12:00:00')
      @article3 = Factory(:article, :title => 'Gettysburg', :author => 'Abe Lincoln', :body => File.open('spec/models/data/Gettysburg.txt', 'r').read, :published_at => 1.month.ago)
  end
  it 'should call the find_by_id method' do
    Article.should_receive(:find_by_id).with(@article1.id).and_return(@article1)
    Article.should_receive(:find_by_id).with(@article2.id).and_return(@article2)
    post :merge, :id=> @article1.id, :merge_with => "#{@article2.id}"
  end
end
