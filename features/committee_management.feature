Feature: Committee Management
  @javascript
  Scenario: Student logs in and adds a faculty to the committee
    Given I am a logged-in student
    And a faculty named "John Doe" exists
    When I navigate to the "Edit Committee" page
    Then I should not see the faculty search fields
    When I click the "Add a Committee Member" button
    Then I should see the faculty search fields
    When I search for a faculty member named "John Doe"
    Then I should be on the "Search Results" page
    And I should see the "Add to Committee" link
    When I click the "Add to Committee" link
    Then I should be on the "Edit Committee" page
    And I should see the flash message "John Doe added to committee!"
    And I should see the faculty member "John Doe" in the committee table

  Scenario: Student assigns a committee chair and ensures only one chair can be set
    Given I am a logged-in student
    And I have two faculty members in my committee
    When I navigate to the "Edit Committee" page
    Then I should see two faculty members in my committee
    And I should see the "Set as Chair" button for both faculty members
    When I click the "Set as Chair" button for the first faculty member
    Then the first faculty member should be set as "Chair"
    And I should see the "Return to Member" button for the first faculty member
    And I should not see the "Set as Chair" button for the second faculty member

  Scenario: Student with no faculty assigned to their committee
    Given I am a logged-in student
    When I navigate to the "Edit Committee" page
    Then I should see the message "You have not added any faculty to your committee yet."

  @javascript
  Scenario: Student searches for a non-existent faculty member
    Given I am a logged-in student
    When I navigate to the "Edit Committee" page
    And I click the "Add a Committee Member" button
    And I search for a faculty member named "NonExistent Faculty"
    Then I should be on the "Edit Committee" page
    And I should see the message "No faculty found with name NonExistent Faculty."

  @javascript
  Scenario: Student adds a faculty member to their committee who is already on their committee
    Given I am a logged-in student
    And I have a faculty member named "John Doe" in my committee
    When I navigate to the "Edit Committee" page
    And I click the "Add a Committee Member" button
    And I search for a faculty member named "John Doe"
    And I click the "Add to Committee" link
    Then I should be on the "Edit Committee" page
    And I should see the message "John Doe is already in your committee."
