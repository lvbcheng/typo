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
  And I follow "G3"

  Scenario: I should see the merge dialog
  And I should see "Merge Articles"

  Scenario: With a valid id, I should be able to press "Merge"
  When I fill in "merge_with" with the id for "G4"
  And I press "Merge"
  And I follow "G3"
  Then I should see "Kotter!!!"

  Scenario: I should gracefully fail when merging with target id of the article
  When I fill in "merge_with" with the id for "G3"
  And I press "Merge"
  Then I should be on the edit article page for "G3"

  Scenario: Successfully merge two articles
  When I fill in "merge_with" with the id for "G4"
  And I press "Merge"
  And I follow "G3"
  Then I should see "Kotter!!!"

  Scenario: After merging two articles, other articles should still be there
  When I fill in "merge_with" with the id for "G4"
  And I press "Merge"
  Then I should see "G1"
  And I should see "G2"
  And I should see "G3"

  Scenario: I should gracefully fail when merging without specifying a target id
  When I press "Merge"
  Then I should be on the edit article page for "G3"

  Scenario: I should gracefully fail when merging with a bogus target id
  When I fill in "merge_with" with "foobar"
  And I press "Merge"
  Then I should be on the edit article page for "G3"

