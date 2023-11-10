Feature: Admin log in
 Scenario: Log in Wrong password
    Given a admin with the email ID "admin@tamu.edu" already exists
    When I am on the Admin Log in page
    And I fill in "email_id" with "admin@tamu.edu"
    And I fill in "password" with "wrong"
    And I submit login form
    Then I should see "Invalid Email or password."

 Scenario: Log in Wrong Email
    Given a admin with the email ID "admin@tamu.edu" already exists
    When I am on the Admin Log in page
    And I fill in "email_id" with "wrong@tamu.com"
    And I fill in "password" with "password"
    And I submit login form
    Then I should see "Invalid Email or password."

  Scenario: Log in correct credentials
    Given a admin with the email ID "admin@tamu.edu" already exists
    When I am on the Admin Log in page
    And I fill in "email_id" with "admin@tamu.edu"
    And I fill in "password" with "password"
    And I submit login form
    Then I should see "Admin Dashboard"