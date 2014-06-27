# Add a declarative step here for populating the DB with articles.

Given /the following articles exist/ do |articles_table|
  # we save articles_created to a hash for use later when we select
  # from the database and compare the output
  @articles_created = articles_table.hashes
  articles_table.hashes.each do |c|
    Article.create! :title => c["title"], :type => c["type"], :author => c["author"], :body => c["body"], :allow_pings => true, :allow_comments => true, :name => c["name"], :post_type => c["post_type"], :published => true
  end
end
