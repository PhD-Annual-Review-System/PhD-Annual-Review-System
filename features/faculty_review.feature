Feature: Faculty reviewing a student

  Background:
    Given a faculty with the email ID "faculty@tamu.edu" already exists
    When I am on the Faculty Log in page
    And I fill in "email_id" with "faculty@tamu.edu"
    And I fill in "password" with "password"
    And I submit login form
    And there is a student named "Test Student"
    And the student has uploaded documents
    And the student is assigned to the faculty
    And the faculty is logged in