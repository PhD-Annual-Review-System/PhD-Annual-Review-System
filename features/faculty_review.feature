Feature: Faculty reviewing a student

  Background:
    Given there is a faculty with email "faculty@tamu.com" and password "password"
    And there is a student named "Test Student"
    And the student is assigned to the faculty
    And the faculty is logged in

  Scenario: Faculty can review a student's documents
    When the faculty selects to review "Test Student"
    Then they should see the student's documents