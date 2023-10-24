Feature: Sign up a new user
  Scenario: Name is blank in form
    Given I am on the sign up page
    When I submit form with empty name
    Then I should see "prohibited this student from being saved"

  Scenario: Passwords don't match
    Given I am on the sign up page
    When I fill in "password" with "XYZ"
    And I fill in "confirm_password" with "XYZ123"
    And I submit form
    Then I should see "prohibited this student from being saved"

  Scenario: Signing up with wrong email. Email not ending with @tamu.edu
    Given I am on the sign up page
    When I fill in "first_name" with "John"
    And I fill in "last_name" with "Doe"
    And I fill in "UIN" with "12345"
    And I fill in "email_id" with "john@tamu.com"
    And I fill in "password" with "password"
    And I fill in "confirm_password" with "password"
    And I submit form
    Then I should see "prohibited this student from being saved"

  Scenario: Signing up with partial email
    Given I am on the sign up page
    When I fill in "first_name" with "John"
    And I fill in "UIN" with "12345"
    And I fill in "email_id" with "john@tamu.com"
    And I fill in "password" with "password"
    And I fill in "confirm_password" with "password"
    And I submit form
    Then I should see "prohibited this student from being saved"

  Scenario: Signing up with a duplicate Email ID
    Given a student with the email ID "john@tamu.edu" already exists
    When I am on the sign up page
    And I fill in "first_name" with "John"
    And I fill in "last_name" with "Doe"
    And I fill in "UIN" with "12345"
    And I fill in "email_id" with "john@tamu.edu"
    And I fill in "password" with "password"
    And I fill in "confirm_password" with "password"
    And I submit form
    Then I should see "prohibited this student from being saved"

  Scenario: Password length less than 8
    Given I am on the sign up page
    When I fill in "first_name" with "John"
    And I fill in "UIN" with "12345"
    And I fill in "email_id" with "john@tamu.com"
    And I fill in "password" with "short"
    And I fill in "confirm_password" with "short"
    And I submit form
    Then I should see "prohibited this student from being saved"

  Scenario: Signing up with valid information
    Given I am on the sign up page
    When I fill in "first_name" with "John"
    And I fill in "last_name" with "Doe"
    And I fill in "UIN" with "12345"
    And I fill in "email_id" with "john@tamu.edu"
    And I fill in "password" with "password"
    And I fill in "confirm_password" with "password"
    And I submit form
    Then I should be redirected to student document path
