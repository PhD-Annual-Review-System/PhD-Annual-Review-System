class StudentDocumentsController < ApplicationController
  before_action :set_student_document, only: %i[ show edit update destroy ]

  # GET /student_documents or /student_documents.json
  def index
    @student_documents = StudentDocument.all
  end

  # GET /student_documents/1 or /student_documents/1.json
  def show
  end

  # GET /student_documents/new
  def new
    @student_document = StudentDocument.new
  end

  # GET /student_documents/1/edit
  def edit
  end

  # POST /student_documents or /student_documents.json
  def create
    @student_document = StudentDocument.new(student_document_params)

    respond_to do |format|
      if @student_document.save
        format.html { redirect_to student_document_url(@student_document), notice: "Student document was successfully created." }
        format.json { render :show, status: :created, location: @student_document }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @student_document.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /student_documents/1 or /student_documents/1.json
  def update
    respond_to do |format|
      if @student_document.update(student_document_params)
        format.html { redirect_to student_document_url(@student_document), notice: "Student document was successfully updated." }
        format.json { render :show, status: :ok, location: @student_document }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @student_document.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /student_documents/1 or /student_documents/1.json
  def destroy
    @student_document.destroy

    respond_to do |format|
      format.html { redirect_to student_documents_url, notice: "Student document was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_student_document
      @student_document = StudentDocument.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def student_document_params
      params.require(:student_document).permit(:first_name, :last_name, :UIN, :resume_present, :link_to_pdf)
    end
end
