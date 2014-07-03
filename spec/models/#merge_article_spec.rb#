require 'spec_helper'
require 'debugger'

describe Article do

  before do
    @blog = stub_model(Blog)
    @blog.stub(:base_url) { "http://myblog.net" }
    @blog.stub(:text_filter) { "textile" }
    @blog.stub(:send_outbound_pings) { false }

    Blog.stub(:default) { @blog }

    @articles = []
  end

  def assert_results_are(*expected)
    assert_equal expected.size, @articles.size
    expected.each do |i|
      assert @articles.include?(i.is_a?(Symbol) ? contents(i) : i)
    end
  end

  describe "merge" do
    before do
      @article_1 = Factory(:article, :title => 'Gettysburg', :author => 'Abe Lincoln', :body => File.open('spec/models/data/Gettysburg.txt', 'r').read, :published_at => 1.month.ago)
      @article_2 = Factory(:article, :title => 'Goto', :author => 'E Djikstra', :body => File.open('spec/models/data/Djikstra1.txt', 'r').read, :published_at => 2.month.ago)
      @article_3 = Factory(:article, :title => 'Let It Go', :author => 'K Anderson Lopez', :body => File.open('spec/models/data/LetItGo.txt', 'r').read, :published_at => 3.month.ago)
      @article_4 = Factory(:article, :title => 'Psalm 23', :author => 'David', :body=>File.open('spec/models/data/Psalm23.txt', 'r').read, :published_at => 1.year.ago)

      @ham_comment = Factory(:comment, :article => @article_2)
    end

    it 'with a bogus article should fail gracefully' do
      expect {@article_4.merge(0)}.to raise_error(Article::InvalidIDError)
    end

    it 'an article with itself should fail gracefully' do
      expect {@article_3.merge(@article_3.id)}.to raise_error(Article::SelfMergeError)
    end

    it 'if successful, the number of articles should be reduced by one' do
      before_merge_count = Article.all.size
      @article_2.merge(@article_3.id)
      expect(Article.all.size).to eq(before_merge_count - 1)
    end

    it 'the source article should contain comments from the target article' do
      @article_1.merge(@article_2.id)
      expect(@article_1.comments.all).to eq([@ham_comment])
    end
  end
end
