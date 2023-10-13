Given ('I am on the student document page page') do
    visit student_documents_path
end

When ('I have email id populated') do 
    label_element = find('#email_id')
    label_text = label_element.value
end

When ('I click on choose file') do
    find("#resume_file").click
end

When ('I upload a resume file') do
    attach_file(:resume_file, Rails.root.join('features', 'upload_files', 'sample_resume.pdf'))
end

When ('I have not uploaded resume file') do 
    resume_field = find_field('resume_file')
    expect(resume_field.value).to be_blank
end

When ('I click on submit button') do
    find("#submit").click
end

Then ('I should be redirected to the student document path') do 
    visit student_documents_path
end