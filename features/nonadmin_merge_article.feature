Feature: A non-admin should not be able to merge articles
  A non-admin should but not merge articles

  Background:
  Given the blog is set up

  And the following articles exist:
      | title | type    | author  | body    | name | post_type |
      | G1    | Article | Mr Typo | Welcome | nil  | read      |

  And I am logged in as "HerbCain" with password "bbbbb"
  
  Scenario:
  When I follow "All Articles" within "div.sidebar"
  And I follow "G1"
  Then I should not see "Merge"
