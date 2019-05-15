class EvaluationController < ApplicationController

  before_filter :admin_only, only: [:evaluate, :save_evaluation, :select_user_for_evaluation_redirection, :select_user_for_evaluation, :courses_admin]

  def show
    @per_page = 3
    @course = Course.find(params[:course_id])
    @evaluation = UserEvaluation.where(:course_id => @course.id, :user_id => current_user.id).first
    @questionnaire = Questionnaire.where(:course_id => @course.id).first
    if !@course.all_subscribed and !@questionnaire.nil? and @questionnaire.visible
      if @evaluation.nil?
          @evaluation = UserEvaluation.new
          @evaluation.course_id = @course.id
          @evaluation.user_id = current_user.id
          @evaluation.questionnaire_id = @questionnaire.id
          @evaluation.save
          @questionnaire.questions.order('id ASC').each do |question|
            evaluation_question = QuestionAnswer.new
            evaluation_question.questionnaire_id = @questionnaire.id
            evaluation_question.question_id = question.id
            evaluation_question.user_evaluation_id = @evaluation.id
            evaluation_question.save
          end
        elsif @evaluation.sent
          redirect_to root_path
        end
        @questions = QuestionAnswer.where(:questionnaire_id => @questionnaire.id, :user_evaluation_id => @evaluation.id).order('question_id') #.paginate(page: params[:page], per_page: @per_page)
    else
      redirect_to root_path
    end
  end

  def send_evaluation
    params.permit!
    @evaluation = UserEvaluation.find(params[:id])
    params[:answer].each do |key, value|
      question_answer = @evaluation.question_answers.order('question_id ASC')[key.to_i]
      question_answer.update_attribute(:answer, value)
    end
    @evaluation.sent = true
    @evaluation.save
    redirect_to evaluation_sent_path(:id => @evaluation.id)
  end

  def evaluation_sent
    @evaluation = UserEvaluation.find(params[:id])
  end

  def select_user_for_evaluation
    @user = User.new
    @course = Course.find(params[:course_id])
    @users = User.joins('LEFT JOIN user_evaluations ON user_evaluations.user_id = users.id')
                 .where(:user_evaluations => {:course_id => @course.id, :sent => true}).order('last_name asc')
  end

  def select_user_for_evaluation_redirection
    user_evaluation = UserEvaluation.where(:course_id => params[:course_id], :user_id => params[:user][:id]).first
    unless user_evaluation.nil?
      redirect_to evaluate_path(:id => user_evaluation.id)
    else
      redirect_to root
    end
  end

  def evaluate
    @user_evaluation = UserEvaluation.find(params[:id])
    @questionnaire = Questionnaire.find(@user_evaluation.questionnaire_id)
    @questions = Question.where(:questionnaire_id => @questionnaire.id).order('id ASC')
    @course = Course.find(@user_evaluation.course_id)
    @user = User.find(@user_evaluation.user_id)
  end

  def save_evaluation
    params.permit!
    @user_evaluation = UserEvaluation.find(params[:id])
    @user_evaluation.update_attributes(params[:user_evaluation])
    redirect_to evaluate_path(:id => @user_evaluation.id)
  end

end
