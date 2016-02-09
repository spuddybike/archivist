class CcQuestionsController < ApplicationController
  before_action :set_cc_question, only: [:show, :edit, :update, :destroy]
  before_action :set_instrument, only: [:new, :create, :index]

  # GET /cc_questions
  # GET /cc_questions.json
  def index
    @cc_questions = @instrument.cc_questions
  end

  # GET /cc_questions/1
  # GET /cc_questions/1.json
  def show
  end

  # POST /cc_questions
  # POST /cc_questions.json
  def create
    @cc_question = @instrument.cc_questions.new(cc_question_params)

    respond_to do |format|
      if @cc_question.save
        format.json { render :show, status: :created }
      else
        format.json { render json: @cc_question.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /cc_questions/1
  # PATCH/PUT /cc_questions/1.json
  def update
    respond_to do |format|
      if @cc_question.update(cc_question_params)
        format.json { render :show, status: :ok }
      else
        format.json { render json: @cc_question.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /cc_questions/1
  # DELETE /cc_questions/1.json
  def destroy
    @cc_question.destroy
    respond_to do |format|
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_cc_question
      @cc_question = CcQuestion.find(params[:id])
    end

    def set_instrument
      @instrument = Instrument.find(params[:instrument_id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def cc_question_params
      params.require(:cc_question).permit(:question_id, :question_type, :instrument_id, :response_unit_id)
    end
end
