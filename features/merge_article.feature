Feature: Merge Articles
  As a blog administrator
  In order to reduce the number of duplicate articles
  I want to be able to combine two articles together

  Background:
  Given the blog is set up
  And I am logged into the admin panel
  And the following articles exist:
      | title | type    | author  | body    | name | post_type |
      | G1    | Article | Mr Typo | Welcome | nil  | read      |
      | G2    | Article | Ms Typo | Back    | nil  | read      |
      | G3    | Article | Dr Typo | Kotter  | nil  | read      |
      | G4    | Article | Dr Typo | !!!     | nil  | read      |

  Scenario: I should see the merge dialog
  And I follow "All Articles" within "div.sidebar"
  And I follow "G4"
  Then I should see "Uploads"
  And I should see "Merge Articles"
  When I press "Merge"
  Then show me the page

# Scenario: I should successfully merge two articles
#  When I merge two articles
#  Then the merged article should have the text of both previous articles
#  And the merged article should have one author
#  And the merged article should have one title
#
#  Scenario: Successfully merge two articles
#  When I merge two articles
#  Then comments on each of the two original articles need to all carry over and point to the new, merged article.
#
#  Scenario: After merging two articles, other articles should still be there
#

