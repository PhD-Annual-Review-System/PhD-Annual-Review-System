json.extract! student_document, :id, :resume_file, :resume_link, :email_id, :created_at, :updated_at
json.url student_document_url(student_document, format: :json)
