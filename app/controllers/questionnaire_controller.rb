class QuestionnaireController < ApplicationController

  before_filter :admin_only

  def new
    params.permit!
    @course = Course.find(params[:course_id])
    @questionnaire = Questionnaire.find_by_course_id(@course.id)
    if @questionnaire.nil?
      @questionnaire = Questionnaire.new
      @questionnaire.visible = false
      @questionnaire.course_id = @course.id
      @questionnaire.save
    end
  end

  def update
    questionnaire = Questionnaire.find(params[:questionnaire_id])
    questionnaire.update_attribute(:visible, params[:questionnaire][:visible])
    redirect_to new_questionnaire_path(:questionnaire_id => questionnaire.id)
  end

  def new_question
    params.permit!
    @questionnaire = Questionnaire.find(params[:questionnaire_id])
    @question = Question.new
    @question.questionnaire_id = @questionnaire.id
    @question_alternatives = Array.new
    q = Question.new
    for i in 1..5 do
      @question_alternatives.push(q)
    end
  end

  def create_question
    params.permit!
    @questionnaire = Questionnaire.find(params[:questionnaire_id])
    @question = Question.new
    @question.text = params[:question][:text]
    @question.correct_answer = params[:question][:correct_answer]
    last_question = Question.where(:questionnaire_id => @questionnaire.id).order('id ASC').last

    @question.position = ( last_question.nil? ? 1 : last_question.position + 1 )
    @question.questionnaire_id = @questionnaire.id

    if @question.save
      position = ['A', 'B', 'C', 'D', 'E']
      for i in 0..4 do
        question_alternative = QuestionAlternative.new
        question_alternative.question_id = @question.id
        question_alternative.text = params[:question][:question_alternatives][i][:text]
        question_alternative.position = position[i]
        question_alternative.save
      end
      redirect_to new_questionnaire_path(:course_id => @questionnaire.course_id)
    else
      redirect_to new_question_path(:questionnaire_id => @questionnaire.id)
    end

  end
  def edit_question
    @question = Question.find(params[:question_id])
  end

  def update_question
    params.permit!
    i=0
    @question = Question.find(params[:question_id])
    @questionnaire = Questionnaire.find(@question.questionnaire_id)
    @question.update_attributes(:text => params[:question][:text], :correct_answer => params[:question][:correct_answer])
    params[:question][:question_alternatives].each do |key, value|
      @question.question_alternatives.order('id asc')[i].update_attribute(:text, value[:text])
      i = i+1
    end
    redirect_to new_questionnaire_path(:course_id => @questionnaire.course_id)
  end

  def delete_question
    q = Question.find(params[:question_id])
    @questionnaire = Questionnaire.find(@question.questionnaire_id)
    q.question_alternatives.each do |qa|
      qa.destroy
    end
    q.destroy
    redirect_to new_questionnaire_path(:course_id => @questionnaire.course_id)
  end

end
