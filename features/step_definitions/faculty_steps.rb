# features/step_definitions/faculty_steps.rb

Given("I am on the Faculty Log in page") do
    visit faculty_login_path
end

Given("a faculty with the email ID {string} already exists") do |email|
    Faculty.create(email_id: email, password: 'password', password_confirmation: 'password', first_name: 'john', last_name: 'doe')
  end