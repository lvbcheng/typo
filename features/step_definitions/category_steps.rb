# Add a declarative step here for populating the DB with categories.

Given /the following categories exist/ do |categories_table|
  # we save categories_created to a hash for use later when we select
  # from the database and compare the output
  @categories_created = categories_table.hashes
  categories_table.hashes.each do |c|
    Category.create! :name => c["name"], :position => c["position"], :permalink => c["permalink"], :keywords => c["keywords"], :description => c["description"], :parent_id => c["parent_id"]
  end
end
