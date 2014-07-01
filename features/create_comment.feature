Feature: Create Comment
  As a contributor to the blog
  I want to comment on an article

Background: The blog has been set up
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

  Scenario: I should see comments belonging to G1
    And I am on the feedback page for article "G1"
    Then I should see "Great article!"
    And I should see "What? You drunk?"
    And I should not see "Herb Cain thumbs up!"

  Scenario: I should see comments belonging to G1
    And I am on the feedback page for article "G2"
    Then I should see "Herb Cain thumbs up!"
    And I should not see "Great article!"
