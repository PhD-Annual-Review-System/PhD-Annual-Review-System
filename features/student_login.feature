Feature: Student log in
 Scenario: Log in Wrong password
    Given a student with the email ID "student@tamu.edu" already exists
    When I am on the Log in page
    And I fill in "email_id" with "student@tamu.edu"
    And I fill in "password" with "wrong"
    And I submit login form
    Then I should see "Invalid Email or password."

 Scenario: Log in Wrong Email
    Given a student with the email ID "student@tamu.edu" already exists
    When I am on the Log in page
    And I fill in "email_id" with "wrong@tamu.com"
    And I fill in "password" with "password"
    And I submit login form
    Then I should see "Invalid Email or password."

  Scenario: Log in correct credentials
    Given a student with the email ID "student@tamu.edu" already exists
    When I am on the Log in page
    And I fill in "email_id" with "student@tamu.edu"
    And I fill in "password" with "password"
    And I submit login form
    Then I should be redirected to student document path