# Add a declarative step here for populating the DB with comments.

Given /the following comments exist/ do |comments_table|
  # we save comments_created to a hash for use later when we select
  # from the database and compare the output
  @comments_created = comments_table.hashes
  comments_table.hashes.each do |c|
    Comment.create!({:type => "Comment", :author => c["author"], :body => c["body"], :excerpt => nil, :user_id => User.find_by_name(c["user"]).id, :guid => nil, :text_filter => nil, :whiteboard => nil, :article_id => Article.find_by_title(c["article"]).id, :email => nil, :ip => nil, :blog_name => nil, :published => true, :published_at => nil, :state => c["state"], :status_confirmed => false})
  end
end

