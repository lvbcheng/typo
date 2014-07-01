Feature: Merge Articles
  As a blog administrator
  In order to reduce the number of duplicate articles
  I want to be able to combine two articles together

  Background:
  Given the blog is set up
  And I am logged in as "admin" with password "aaaaaaaa"
  And the following articles exist:
      | title | type    | author  | body    | name | post_type |
      | G1    | Article | Mr Typo | Welcome | nil  | read      |
      | G2    | Article | Ms Typo | Back    | nil  | read      |
      | G3    | Article | Dr Typo | Kotter  | nil  | read      |
      | G4    | Article | Dr Typo | !!!     | nil  | read      |

  And I follow "All Articles" within "div.sidebar"

  Scenario: I should not be able to merge a draft article
  And I follow "New Article"
  And I fill in "article_title" with "G5"
  And I should not see "Merge"

