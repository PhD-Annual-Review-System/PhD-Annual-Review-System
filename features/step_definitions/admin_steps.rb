# features/step_definitions/admin_steps.rb

Given("I am on the Admin Log in page") do
    visit admin_login_path
end

Given("a admin with the email ID {string} already exists") do |email|
    Admin.create(email_id: email, password: 'password', password_confirmation: 'password', first_name: 'john', last_name: 'doe')
  end