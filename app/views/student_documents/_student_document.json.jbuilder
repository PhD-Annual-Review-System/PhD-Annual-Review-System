json.extract! student_document, :id, :first_name, :last_name, :UIN, :resume_present, :link_to_pdf, :created_at, :updated_at
json.url student_document_url(student_document, format: :json)
