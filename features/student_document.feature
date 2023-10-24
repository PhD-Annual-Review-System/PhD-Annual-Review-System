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
     And I select the PhD start date as "Fall 2023"
     And I fill in value of "milestones_passed" with "I have completed several important milestones in my PhD."
     And I select value "Yes" from "Improvement Plan Present"
     And I fill in value of "Improvement Plan Summary" with "Summary text"
     And I fill in value of "GPA" with "3.7"
     And I fill in value of "Support in Last Sem" with "Support information"
     And I fill in value of "Number of Paper Submissions" with "5"
     And I fill in value of "Number of Papers Published" with "3"
    When I click on choose file
    When I upload a resume file
     When I click on choose file
    When I upload a report file
    When I click on submit button
    Then I should see a flash notice with the text "Details have been submitted."
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
    Then I should see a flash notice with the text "Errors while updating details."
    Then I should be redirected to the student document path

  Scenario: Submit button is clicked without report attached
   Given a student with the email ID "student@tamu.edu" already exists
    When I am on the Log in page
     And I fill in "email_id" with "student@tamu.edu"
     And I fill in "password" with "password"
     And I submit login form
    Then I should be redirected to the student document path
    Then I am on the student document page page
     And I have email id populated
     And I have not uploaded report file
    When I click on submit button
    Then I should see a flash notice with the text "Errors while updating details."
    Then I should be redirected to the student document path

  Scenario: Submit button is clicked without phd_start_date specified
   Given a student with the email ID "student@tamu.edu" already exists
    When I am on the Log in page
     And I fill in "email_id" with "student@tamu.edu"
     And I fill in "password" with "password"
     And I submit login form
    Then I should be redirected to the student document path
    Then I am on the student document page page
     And I have email id populated
     And I have not updated "PhD start date"
    When I click on submit button
    Then I should see a flash notice with the text "Errors while updating details."
    Then I should be redirected to the student document path

  Scenario: Submit button is clicked without milestones passed specified
   Given a student with the email ID "student@tamu.edu" already exists
    When I am on the Log in page
     And I fill in "email_id" with "student@tamu.edu"
     And I fill in "password" with "password"
     And I submit login form
    Then I should be redirected to the student document path
    Then I am on the student document page page
     And I have email id populated
     And I have not updated "milestones_passed"
    When I click on submit button
    Then I should see a flash notice with the text "Errors while updating details."
    Then I should be redirected to the student document path

  Scenario: Submit button is clicked without Improvement Plan Present specified
   Given a student with the email ID "student@tamu.edu" already exists
    When I am on the Log in page
     And I fill in "email_id" with "student@tamu.edu"
     And I fill in "password" with "password"
     And I submit login form
    Then I should be redirected to the student document path
    Then I am on the student document page page
     And I have email id populated
     And I have not updated "Improvement Plan Present"
    When I click on submit button
    Then I should see a flash notice with the text "Errors while updating details."
    Then I should be redirected to the student document path

Scenario: Submit button is clicked without Improvement Plan Summary specified
   Given a student with the email ID "student@tamu.edu" already exists
    When I am on the Log in page
     And I fill in "email_id" with "student@tamu.edu"
     And I fill in "password" with "password"
     And I submit login form
    Then I should be redirected to the student document path
    Then I am on the student document page page
     And I have email id populated
     And I have not updated "Improvement Plan Summary"
    When I click on submit button
    Then I should see a flash notice with the text "Errors while updating details."
    Then I should be redirected to the student document path

Scenario: Submit button is clicked without GPA specified
   Given a student with the email ID "student@tamu.edu" already exists
    When I am on the Log in page
     And I fill in "email_id" with "student@tamu.edu"
     And I fill in "password" with "password"
     And I submit login form
    Then I should be redirected to the student document path
    Then I am on the student document page page
     And I have email id populated
     And I have not updated "GPA"
    When I click on submit button
    Then I should see a flash notice with the text "Errors while updating details."
    Then I should be redirected to the student document path

Scenario: Submit button is clicked without Support in Last Sem specified
   Given a student with the email ID "student@tamu.edu" already exists
    When I am on the Log in page
     And I fill in "email_id" with "student@tamu.edu"
     And I fill in "password" with "password"
     And I submit login form
    Then I should be redirected to the student document path
    Then I am on the student document page page
     And I have email id populated
     And I have not updated "Support in Last Sem"
    When I click on submit button
    Then I should see a flash notice with the text "Errors while updating details."
    Then I should be redirected to the student document path

Scenario: Submit button is clicked without Number of Paper Submissions specified
   Given a student with the email ID "student@tamu.edu" already exists
    When I am on the Log in page
     And I fill in "email_id" with "student@tamu.edu"
     And I fill in "password" with "password"
     And I submit login form
    Then I should be redirected to the student document path
    Then I am on the student document page page
     And I have email id populated
     And I have not updated "Number of Paper Submissions"
    When I click on submit button
    Then I should see a flash notice with the text "Errors while updating details."
    Then I should be redirected to the student document path

Scenario: Submit button is clicked without Number of Papers Published specified
   Given a student with the email ID "student@tamu.edu" already exists
    When I am on the Log in page
     And I fill in "email_id" with "student@tamu.edu"
     And I fill in "password" with "password"
     And I submit login form
    Then I should be redirected to the student document path
    Then I am on the student document page page
     And I have email id populated
     And I have not updated "Number of Papers Published"
    When I click on submit button
    Then I should see a flash notice with the text "Errors while updating details."
    Then I should be redirected to the student document path