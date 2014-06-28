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

  And I follow "All Articles" within "div.sidebar"
  And I follow "G4"

  Scenario: I should see the merge dialog
  And I should see "Merge Articles"

  Scenario: With a valid id, I should be able to press "Merge"
  When I fill in "merge_target_id" with the id for "G3"
  And I press "Merge"
  Then I should be on the edit article page for "G4"

  Scenario: I should gracefully fail when merging with target id of the article
  When I fill in "merge_target_id" with the id for "G4"
  And I press "Merge"
  Then I should be on the edit article page for "G4"
  When PENDING
  And the flash should read ...

 Scenario: I should successfully merge two articles
  When PENDING
  When I merge two articles
  Then the merged article should have the text of both previous articles
  And the merged article should have one author
  And the merged article should have one title

  Scenario: Successfully merge two articles
  When PENDING
  When I merge two articles
  Then comments on each of the two original articles need to all carry over and point to the new, merged article.

  Scenario: After merging two articles, other articles should still be there

  Scenario: I should gracefully fail when merging without specifying a target id
  When PENDING
  When I press "Merge"
  Then I should be on the edit article page for "G4"

