require "test_helper"

class StudentDocumentsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @student_document = student_documents(:one)
  end

  test "should get index" do
    get student_documents_url
    assert_response :success
  end

  test "should get new" do
    get new_student_document_url
    assert_response :success
  end

  test "should create student_document" do
    assert_difference("StudentDocument.count") do
      post student_documents_url, params: { student_document: { email_id: @student_document.email_id, resume_file: @student_document.resume_file, resume_link: @student_document.resume_link } }
    end

    assert_redirected_to student_document_url(StudentDocument.last)
  end

  test "should show student_document" do
    get student_document_url(@student_document)
    assert_response :success
  end

  test "should get edit" do
    get edit_student_document_url(@student_document)
    assert_response :success
  end

  test "should update student_document" do
    patch student_document_url(@student_document), params: { student_document: { email_id: @student_document.email_id, resume_file: @student_document.resume_file, resume_link: @student_document.resume_link } }
    assert_redirected_to student_document_url(@student_document)
  end

  test "should destroy student_document" do
    assert_difference("StudentDocument.count", -1) do
      delete student_document_url(@student_document)
    end

    assert_redirected_to student_documents_url
  end
end
