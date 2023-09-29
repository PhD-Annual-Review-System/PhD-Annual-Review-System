# features/step_definitions/student_steps.rb

Given("I am on the sign up page") do
    visit student_signup_path
end

Given("I am on the Log in page") do
    visit student_login_path
end


Given("a student with the email ID {string} already exists") do |email|
    Student.create(email_id: email, password: 'password', password_confirmation: 'password', first_name: 'john', last_name: 'doe', UIN: 1234)
  end

When(/^I submit form with empty name$/) do
    find("#submit").click
end

When(/^I fill in "([^"]*)" with "([^"]*)"$/) do |arg1, arg2|
    fill_in(arg1,with: arg2)
  end

Then('I should see {string}') do |content|
    expect(page).to have_content(content)
end

And(/^I submit form$/) do
    find("#submit").click
end

And(/^I submit login form$/) do
    find("#login").click
end