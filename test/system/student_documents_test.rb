require "application_system_test_case"

class StudentDocumentsTest < ApplicationSystemTestCase
  setup do
    @student_document = student_documents(:one)
  end

  test "visiting the index" do
    visit student_documents_url
    assert_selector "h1", text: "Student documents"
  end

  test "should create student document" do
    visit student_documents_url
    click_on "New student document"

    fill_in "Uin", with: @student_document.UIN
    fill_in "First name", with: @student_document.first_name
    fill_in "Last name", with: @student_document.last_name
    fill_in "Link to pdf", with: @student_document.link_to_pdf
    fill_in "Resume present", with: @student_document.resume_present
    click_on "Create Student document"

    assert_text "Student document was successfully created"
    click_on "Back"
  end

  test "should update Student document" do
    visit student_document_url(@student_document)
    click_on "Edit this student document", match: :first

    fill_in "Uin", with: @student_document.UIN
    fill_in "First name", with: @student_document.first_name
    fill_in "Last name", with: @student_document.last_name
    fill_in "Link to pdf", with: @student_document.link_to_pdf
    fill_in "Resume present", with: @student_document.resume_present
    click_on "Update Student document"

    assert_text "Student document was successfully updated"
    click_on "Back"
  end

  test "should destroy Student document" do
    visit student_document_url(@student_document)
    click_on "Destroy this student document", match: :first

    assert_text "Student document was successfully destroyed"
  end
end
