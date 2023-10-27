Feature: Faculty dashboard

  Background:
    Given there is a faculty with email "faculty@tamu.edu" and password "password"
    And the faculty is logged in

  Scenario: Faculty can see a list of students to review
    And there are students assigned to the faculty
    When the faculty visits the dashboard
    Then they should see a list of students

  Scenario: Faculty sees a message when no students are assigned
    And there are no students assigned to the faculty
    When the faculty visits the dashboard
    Then they should see a message indicating no students are assigned

  Scenario: Faculty can log out
    When the faculty logs out
    Then they should be redirected to the login page