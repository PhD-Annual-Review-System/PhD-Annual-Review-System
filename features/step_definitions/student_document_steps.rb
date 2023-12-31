Given ('I am on the student document page page') do
    visit student_documents_path
end

When ('I have email id populated') do 
    label_element = find('#email_id')
    label_text = label_element.value
end

Then("I select the PhD start date as {string}") do |start_date|
    select start_date, from: 'student_document[phd_start_date]'
end

When('I select milestones that should include the following:') do |milestones_table|
    milestones = milestones_table.raw.flatten
    milestones.each do |milestone|
      find("input[type='checkbox'][value='#{milestone}']").check
    end
end

Then("I fill in the support descriptions") do
    support_values = ["Research Assistantship with Faculty Member", "Teaching Assistantship", "Fellowship", "Job within TAMU", "Job outside TAMU", "Other"]
    descriptions = ["Description 1", "Description 2", "Description 3", "Description 4", "Description 5", "Description 6"]
  
    support_values.each_with_index do |value, index|
      checkboxes = all("input[type='checkbox'][value='#{value}']")
      checkboxes.first.set(true) # Ensure we select the first matching checkbox
  
      description_inputs = all("input[type='text'][name='student_document[support_in_last_sem_description][]']")
      description_inputs[index].set(descriptions[index])
    end
  end

Then("I select value {string} from {string}") do |value, field_name|
    select value, from: "student_document_#{field_name.parameterize.underscore}"
end

When("I fill in value of {string} with {string}") do |field_name, value|
  fill_in "student_document_#{field_name.parameterize.underscore}", with: value
end

When ('I click on choose file') do
    find("#resume_file").click
end

When ('I upload a resume file') do
    attach_file(:resume_file, Rails.root.join('features', 'upload_files', 'sample_resume.pdf'))
end

When ('I upload a report file') do
    attach_file(:report_file, Rails.root.join('features', 'upload_files', 'sample_resume.pdf'))
end

When ('I have not uploaded resume file') do 
    resume_field = find_field('resume_file')
    expect(resume_field.value).to be_blank
end

When ('I have not uploaded report file') do 
    resume_field = find_field('report_file')
    expect(resume_field.value).to be_blank
end

When ('I click on submit button') do
    find("#submit").click
end

Then ('I should be redirected to the student document path') do 
    visit student_documents_path
end

Then("I should see a flash notice with the text {string}") do |message|
    expect(page).to have_content(message)
end

Then("I have not updated {string}") do |field_name|
    expect(find("#student_document_#{field_name.parameterize.underscore}").value).to eq("")
end

  