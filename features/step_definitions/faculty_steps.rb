# features/step_definitions/faculty_steps.rb

Given("I am on the Faculty Log in page") do
    visit faculty_login_path
end

Given("a faculty with the email ID {string} already exists") do |email|
    Faculty.create(email_id: email, password: 'password', password_confirmation: 'password', first_name: 'john', last_name: 'doe')
  end

  Given('there is a faculty with email {string} and password {string}') do |email, password|
    Faculty.create(email_id: email, password: password, password_confirmation: password, first_name: 'test', last_name: 'test')
  end
  
  Given('the faculty is logged in') do
    @faculty = Faculty.find_by(email_id: 'faculty@tamu.edu')
    visit faculty_login_path
    fill_in("email_id",with: 'faculty@tamu.edu')
    fill_in("password",with: 'password')
    find("#login").click
  end
  
  Given('there are students assigned to the faculty') do
    faculty = @faculty
    student = Student.create(email_id: 'test@tamu.edu', password: 'password', password_confirmation: 'password', first_name: 'test', last_name: 'test', UIN: 1234)
    Committee.create(student: student, faculty: faculty)
  end
  
  When('the faculty visits the dashboard') do
    visit faculty_dashboard_path
  end
  
  Then('they should see a list of students') do
    expect(page).to have_content('test') # Write code here that turns the phrase above into concrete actions
  end
  
  Given('there are no students assigned to the faculty') do
  end
  
  Then('they should see a message indicating no students are assigned') do
    expect(page).to have_content('No review Completed so far.')
    expect(page).to have_content('No students are pending for review.')
  end
  
  When('the faculty logs out') do
    click_link 'Logout'
  end
  
  Then('they should be redirected to the login page') do
    expect(current_path).to eq(faculty_login_path)
  end

  Given('there is a student named {string}') do |name|
    @student = Student.create(email_id: 'test@tamu.edu', password: 'password', password_confirmation: 'password', first_name: 'Test', last_name: 'Student', UIN: 1234)
  end
  
  Given('the student is assigned to the faculty') do
    faculty = @faculty
    student = @student
    Committee.create(student: student, faculty: faculty) 
  end
  
  When('the faculty selects to review {string}') do |string|
    student = @student
    visit faculty_review_student_path(student)
  end
  
  Then('they should see the student\'s documents') do
    expect(page).to have_content('Submitting Review for Test Student') 
  end