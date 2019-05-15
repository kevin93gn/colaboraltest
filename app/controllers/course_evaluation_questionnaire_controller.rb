class CourseEvaluationQuestionnaireController < ApplicationController

    before_filter :admin_only, only: [:show, :update, :new_question, :create_question, :edit_question, :update_question]

    def show
      params.permit!
      @course = Course.find(params[:course_id])
      @evaluation = CourseEvaluation.find(params[:evaluation_id])
      @questionnaire = CourseEvaluationQuestionnaire.where(:course_id => @course.id, :evaluation_id => @evaluation.id).first
      if @questionnaire.nil?
        @questionnaire = CourseEvaluationQuestionnaire.new
        @questionnaire.visible = false
        @questionnaire.course_id = @course.id
        @questionnaire.evaluation_id = @evaluation.id
        @questionnaire.save
      end
    end

    def update
      questionnaire = CourseEvaluationQuestionnaire.find(params[:questionnaire_id])
      questionnaire.update_attribute(:visible, params[:course_evaluation_questionnaire][:visible])
      redirect_to course_evaluation_questionnaire_path(:questionnaire_id => questionnaire.id)
    end

    def new_question
      params.permit!
      @course = Course.find(params[:course_id])
      @evaluation = CourseEvaluation.find(params[:evaluation_id])

      @questionnaire = CourseEvaluationQuestionnaire.find(params[:questionnaire_id])
      @question = CourseEvaluationQuestion.new
      @question.course_evaluation_questionnaire_id = @questionnaire.id

      @question_alternatives = Array.new
      q = CourseEvaluationQuestion.new
      for i in 1..5 do
        @question_alternatives.push(q)
      end
    end

    def create_question
      params.permit!
      @course = Course.find(params[:course_id])
      @questionnaire = CourseEvaluationQuestionnaire.find(params[:questionnaire_id])
      @question = CourseEvaluationQuestion.new
      @question.text = params[:course_evaluation_question][:text]
      @question.correct_answer = params[:course_evaluation_question][:correct_answer]
      last_question = @questionnaire.course_evaluation_questions.order('id ASC').last

      @question.position = ( last_question.nil? ? 1 : last_question.position + 1 )
      @question.course_evaluation_questionnaire_id= @questionnaire.id
      if params[:course_evaluation_question][:question_alternatives].to_a.length == 5 and @question.save
        position = ['A', 'B', 'C', 'D', 'E']
        for i in 0..4 do
          text = params[:course_evaluation_question][:question_alternatives][i][:text]
          question_alternative = CourseEvaluationQuestionAlternative.new
          question_alternative.course_evaluation_question_id = @question.id
          question_alternative.text = text
          question_alternative.position = position[i]
          question_alternative.save
        end
        redirect_to course_evaluation_questionnaire_path(:course_id => @questionnaire.course_id)
      else
        @question_alternatives = Array.new
        q = CourseEvaluationQuestion.new
        for i in 1..5 do
          @question_alternatives.push(q)
        end
        render :new_question
      end

    end
    def edit_question
      @question = CourseEvaluationQuestion.find(params[:question_id])
      @course = Course.find(params[:course_id])
      @evaluation = CourseEvaluation.find(params[:evaluation_id])
    end

    def update_question
      params.permit!
      i=0
      @question = CourseEvaluationQuestion.find(params[:question_id])
      @evaluation = CourseEvaluation.find(params[:evaluation_id])
      @question.update_attributes(:text => params[:course_evaluation_question][:text], :correct_answer => params[:course_evaluation_question][:correct_answer])
      params[:course_evaluation_question][:question_alternatives].each do |key, value|
        @question.course_evaluation_question_alternatives.order('id asc')[i].update_attribute(:text, value[:text])
        i = i+1
      end
      redirect_to course_evaluation_questionnaire_path(:course_id => @evaluation.course_id, :evaluation_id => @evaluation.id)
    end

    def evaluate
      @per_page = 3
      @course = Course.find(params[:course_id])
      @evaluation = CourseUserEvaluation.where(:course_id => @course.id, :module_item_id => params[:module_item_id], :user_id => current_user.id ).first
      @course_evaluation = CourseEvaluation.where(:course_id => @course.id, :module_item_id => params[:module_item_id]).first
      @questionnaire = CourseEvaluationQuestionnaire.where(:course_id => @course.id, :evaluation_id => @course_evaluation.id).first
      @module_item = ModuleItem.find(params[:module_item_id])
      if !@questionnaire.nil? and @questionnaire.visible
        if @evaluation.nil?
          @evaluation = CourseUserEvaluation.new
          @evaluation.course_id = @course.id
          @evaluation.user_id = current_user.id
          @evaluation.module_item_id = @module_item.id
          @evaluation.course_evaluation_questionnaire_id = @questionnaire.id
          @evaluation.sent = false
          @evaluation.save
          a = @questionnaire.course_evaluation_questions.count
          @questionnaire.course_evaluation_questions.order('id ASC').each do |question|
            evaluation_question = CourseEvaluationAnswer.new
            evaluation_question.evaluation_questionnaire_id = @questionnaire.id
            evaluation_question.course_evaluation_question_id = question.id
            evaluation_question.course_user_evaluation_id = @evaluation.id
            evaluation_question.save!
          end
        elsif @evaluation.sent
          redirect_to root_path
        end
        @questions = CourseEvaluationAnswer.where(:evaluation_questionnaire_id => @questionnaire.id, :course_user_evaluation_id => @evaluation.id) #.paginate(page: params[:page], per_page: @per_page)
      else
        redirect_to root_path
      end
    end

    def send_evaluation
      params.permit!
      error = false
      @evaluation = CourseUserEvaluation.find(params[:id])
      @questionnaire = CourseEvaluationQuestionnaire.find(@evaluation.course_evaluation_questionnaire_id)
      @module_item_user = ModuleItemsUsers.where(:course_id => @evaluation.course_id, :user_id => current_user.id, :module_item_id => @evaluation.module_item_id).first
      params[:answer].each do |key, value|
        alternative = value
        if alternative == 'None'
          error=true
          break
        end
        question_answer = @evaluation.course_evaluation_answers.order('course_evaluation_question_id ASC')[key.to_i]
        question_answer.update_attribute(:answer, value)
      end
      unless error
        @evaluation.sent = true
        if @evaluation.save
          @grade = Grade.new
          @grade.course_id = @evaluation.course_id
          @grade.course_evaluation_id = @questionnaire.evaluation_id
          @grade.grade = 0
          @grade.user_id = current_user.id
          @grade.save!
          @module_item_user.update_attribute(:sent, true)
        end
        redirect_to course_evaluation_sent_path(:id => @evaluation.id)
      else
        @module_item = ModuleItem.find(params[:module_item_id])
        @course = Course.find(params[:course_id])
        @questionnaire = CourseEvaluationQuestionnaire.where(:course_id => @course.id).first
        @questions = CourseEvaluationAnswer.where(:evaluation_questionnaire_id => @questionnaire.id, :course_user_evaluation_id => @evaluation.id) #.paginate(page: params[:page], per_page: @per_page)
        @error = 'Debes contestar todas las preguntas'
        render :evaluate
      end
    end

    def evaluation_sent
      @evaluation = CourseUserEvaluation.find(params[:id])
    end




end

