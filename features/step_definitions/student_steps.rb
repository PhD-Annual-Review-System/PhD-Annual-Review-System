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

# For committee management feature
# Scenario: Student logs in and adds a faculty to the committee
Given('I am a logged-in student') do
    @student = FactoryBot.create(:student, email_id: 'studenttest@tamu.edu', password: 'password')
  
    visit student_login_path
    fill_in 'email_id', with: 'studenttest@tamu.edu'
    fill_in 'password', with: 'password'
    find("#login").click
end

Given('a faculty named {string} exists') do |faculty_name|
    faculty_first, faculty_last = faculty_name.split(' ')
    @faculty = FactoryBot.create(:faculty, first_name: faculty_first, last_name: faculty_last, email_id: 'johndoetest@tamu.edu', password: 'password')
end
  
When('I navigate to the {string} page') do |page_name|
    path = case page_name
    when 'Edit Committee'
        edit_committee_student_path
    end
    # add other page names here
    # when "Some Other Page"
    #   return some_other_page_path
    # end
    visit path
end

Then('I should not see the faculty search fields') do
    expect(page).not_to have_field('first_name')
    expect(page).not_to have_field('last_name')
end

When('I click the {string} button') do |button_name|
    click_button button_name
end

Then('I should see the faculty search fields') do
    expect(page).to have_css('div#searchForm', visible: true)
end

When('I search for a faculty member named {string}') do |faculty_name|
    faculty_first, faculty_last = faculty_name.split(' ')
    fill_in 'first_name', with: faculty_first
    fill_in 'last_name', with: faculty_last
    find("#search").click
end

Then('I should be on the {string} page') do |page_name|
    expected_path = case page_name
    when 'Edit Committee'
        edit_committee_student_path
    when 'Search Results'
        search_faculty_student_path
    when 'View Assessments'
        student_view_assessments_path(@student)
    end
    expect(current_path).to eq(expected_path)
end
  
Then('I should see the {string} link') do |link_name|
    expect(page).to have_link(link_name)
end

When('I click the {string} link') do |link_name|
    click_link link_name
end

Then("I should see the flash message {string}") do |message|
    expect(page).to have_content(message)
end

Then('I should see the faculty member {string} in the committee table') do |faculty_name|
    faculty_first, faculty_last = faculty_name.split(' ')
    within('.committee-table') do
        expect(page).to have_content(faculty_first)
        expect(page).to have_content(faculty_last)
    end
end

# Scenario: Student assigns a committee chair and ensures only one chair can be set
Given('I have two faculty members in my committee') do
    @faculty1 = FactoryBot.create(:faculty, first_name: 'Prof1', last_name: 'Test1')
    @faculty2 = FactoryBot.create(:faculty, first_name: 'Prof2', last_name: 'Test2')
    FactoryBot.create(:committee, student: @student, faculty: @faculty1)
    FactoryBot.create(:committee, student: @student, faculty: @faculty2)
end

Then('I should see two faculty members in my committee') do
    expect(page).to have_content(@faculty1.first_name)
    expect(page).to have_content(@faculty1.last_name)
    expect(page).to have_content(@faculty2.first_name)
    expect(page).to have_content(@faculty2.last_name)
end

And('I should see the {string} button for both faculty members') do |string|
    within("tr", text: "#{@faculty1.first_name} #{@faculty1.last_name}") do
        expect(page).to have_link(string)
    end
    within("tr", text: "#{@faculty2.first_name} #{@faculty2.last_name}") do
        expect(page).to have_link(string)
    end
end
  
When('I click the {string} button for the first faculty member') do |string|
    within("tr", text: "#{@faculty1.first_name} #{@faculty1.last_name}") do
      click_link(string)
    end
end
  
Then('the first faculty member should be set as {string}') do |role|
    within("tr", text: "#{@faculty1.first_name} #{@faculty1.last_name}") do
        expect(page).to have_content(role)
    end
end
  
Then('I should see the {string} button for the first faculty member') do |string|
    within("tr", text: "#{@faculty1.first_name} #{@faculty1.last_name}") do
        expect(page).to have_link(string)
    end
end
  
Then('I should not see the {string} button for the second faculty member') do |string|
    within("tr", text: "#{@faculty1.first_name} #{@faculty1.last_name}") do
        expect(page).not_to have_link(string)
    end
end

# Scenario: Student with no faculty assigned to their committee
Then('I should see the message {string}') do |message|
    expect(page).to have_content(message)
end

# Scenario: Student adds a faculty member to their committee who is already on their committee
Given('I have a faculty member named {string} in my committee') do |string|
    faculty_first, faculty_last = string.split(' ')
    @faculty = FactoryBot.create(:faculty, first_name: faculty_first, last_name: faculty_last, email_id: 'johndoetest@tamu.edu', password: 'password')
    FactoryBot.create(:committee, student: @student, faculty: @faculty)
end

Then ('I should be redirected to student document path') do 
    visit student_documents_path
end

Given('I have two faculty members who have made assessments') do
    @faculty1 = FactoryBot.create(:faculty, first_name: 'Prof1', last_name: 'Test1')
    @faculty2 = FactoryBot.create(:faculty, first_name: 'Prof2', last_name: 'Test2')

    @assessment1 = FactoryBot.create(:assessment, public_comment: 'Excellent work!', rating: 5, eligible_for_reward: true, faculty: @faculty1, student: @student)
    @assessment2 = FactoryBot.create(:assessment, public_comment: 'Needs improvement.', rating: 3, eligible_for_reward: false, faculty: @faculty2, student: @student)
end
  
Then('I should see table with {string} in the {string} column') do |expected_text, column_name|
    headers = page.find('thead').all('th').map(&:text)

    # Check if the column name exists in the headers
    unless headers.include?(column_name)
        raise "Column '#{column_name}' not found in table headers."
    end
    
    column_index = find('thead').all('th').map(&:text).index(column_name) + 1
    
    column_has_text = page.all('tbody tr').any? do |row|
      row.find("td:nth-child(#{column_index})").text == expected_text
    end

    expect(column_has_text).to be true, "Expected to find text #{expected_text} in the #{column_name} column, but did not."
end