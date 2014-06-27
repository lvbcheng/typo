Feature: Create Category
  As an admin/lipQTsZ
  I want to make changes to the categories in my blog

Background: The blog has been set up
     Given the blog is set up
     And I am logged into the admin panel

     And the following categories exist:
      | name  | position | permalink | keywords | description | parent_id |
      | G1    | 1        | nil       | nil      | nil         | nil       |
      | G2    | 2        | nil       | nil      | nil         | nil       |
      | G3    | 3        | nil       | nil      | nil         | nil       |

     And I follow "Categories" within "div.sidebar"
     
  Scenario: I should be able to create a new category
    When I fill in "Name" with "G4"
    And  I press "Save"
    Then show me the page
    And I should see the category "G4"
#   And I should see the flash notice "Category was successfully saved."

  Scenario: I should gracefully cancel creation of a new category

  Scenario: I should see a good error message on creation error
