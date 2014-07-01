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

  And the following comments exist:
      | author  | body                    | user   | article    | state |
      | admin   | Great article!          | admin  | G1         | ham   |
      | Ms Typo | What? You drunk?        | admin  | G1         | ham   |
      | Herb    | Herb Cain thumbs up!    | admin  | G2         | ham   |     

  And I follow "All Articles" within "div.sidebar"

  Scenario: When two articles are merged, their comments should also be merged
  And I am on the feedback page for article "G2"
  Then I should see "Herb Cain thumbs up!"

  Scenario: When two articles are merged, their comments should also be merged
  And I follow "G1"
  And I fill in "merge_with" with the id for "G2"
  And I press "Merge"
  And I am on the feedback page for article "G1"
  Then I should see "Herb Cain thumbs up!"

  
