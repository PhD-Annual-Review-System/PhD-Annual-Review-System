Feature: Student submits student documents
  Scenario: Submit button is clicked with resume attached
   Given a student with the email ID "student@tamu.edu" already exists
    When I am on the Log in page
    And I fill in "email_id" with "student@tamu.edu"
    And I fill in "password" with "password"
    And I submit login form
    Then I should be redirected to the student document path
    Then I am on the student document page page
     And I have email id populated
    When I click on choose file
    When I upload a resume file
    When I click on submit button
    Then I should be redirected to the student document path

  Scenario: Submit button is clicked without resume attached
   Given a student with the email ID "student@tamu.edu" already exists
    When I am on the Log in page
     And I fill in "email_id" with "student@tamu.edu"
     And I fill in "password" with "password"
     And I submit login form
    Then I should be redirected to the student document path
    Then I am on the student document page page
     And I have email id populated
     And I have not uploaded resume file
    When I click on submit button
    Then I should see "Error: Please select a file to upload!"