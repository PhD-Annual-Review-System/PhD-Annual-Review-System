Feature: View Assessments
  As a student
  I want to be able to view assessments made by faculty
  So that I can see feedback on my academic performance

  Scenario: Student views assessments when none are available
    Given I am a logged-in student
    When I click the "View Assessments" link
    Then I should be on the "View Assessments" page
    And I should see "There are currently no assessments ready for your review."