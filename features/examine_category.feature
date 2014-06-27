Feature: Create Category
  As an admin/lipQTsZ
  I want to manage categories

  Background: The blog has been set up
    Given the blog is set up
    And I am logged into the admin panel
    And the following categories exist:
     | name  | position | permalink | keywords | description | parent_id |
     | G1    | 1        | nil       | nil      | nil         | nil       |
     | G2    | 2        | nil       | nil      | nil         | nil       |
     | G3    | 3        | nil       | nil      | nil         | nil       |
    And I follow "Categories" within "div.sidebar"

  Scenario: All categories should be listed
     Then I should see all the categories

  Scenario: I should be able to examine each category
     When I follow "G3" within "table#category_container"
     Then I should be on the edit category page for "G3"


