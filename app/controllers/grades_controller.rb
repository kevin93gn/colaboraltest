class GradesController < ApplicationController


  def index
    @evaluation = CourseEvaluation.find(params[:course_evaluation_id])
    @grades = Grade.where(:course_evaluation_id => params[:course_evaluation_id])
  end


  def show
      @course = Course.find(params[:course_id])
      @grades = Grade.where(:user_id => current_user.id, :course_id => @course.id).where('grade > 0')
  end



  def new
    @evaluation = CourseEvaluation.find(params[:course_evaluation_id])
    @grade = Grade.new
    @grade.course_id = @evaluation.course_id
    users_with_grades = User.joins('RIGHT JOIN grades ON grades.user_id = users.id')
                             .where(:grades => {:course_evaluation_id => @evaluation.id}).pluck(:id)
    users_with_grades.push(0)
    @users = User.joins('RIGHT JOIN subscriptions ON subscriptions.user_id = users.id')
                 .where(:subscriptions => {:course_id => @evaluation.course_id })
                 .where("users.id not in (?)", users_with_grades)
                 .order('last_name asc')
  end

  def create
    params.permit!
    @grade = Grade.new(params[:grade])
    @grade.course_id = params[:course_id]
    @grade.course_evaluation_id = params[:course_evaluation_id]
    if @grade.save
      redirect_to course_evaluations_grades_path(:course_id => @grade.course_id, :course_evaluation_id => @grade.course_evaluation_id)
    else
      @evaluation = CourseEvaluation.find(params[:course_evaluation_id])
      users_with_grades = User.joins('RIGHT JOIN grades ON grades.user_id = users.id')
                              .where(:grades => {:course_evaluation_id => @evaluation.id}).pluck(:id)
      users_with_grades.push(0)
      @users = User.joins('RIGHT JOIN subscriptions ON subscriptions.user_id = users.id')
                   .where(:subscriptions => {:course_id => @evaluation.course_id })
                   .where("users.id not in (?)", users_with_grades)
                   .order('last_name asc')
    render :action => 'new'
  end

  end

  def edit
    @evaluation = CourseEvaluation.find(params[:course_evaluation_id])
    @grade = Grade.find(params[:id])
    @grade.course_id = @evaluation.course_id
    @users = User.where(:id => @grade.user_id )
  end

  def update
    params.permit!
    @grade = Grade.find(params[:id])
    if @grade.update(:grade => params[:grade][:grade])
      redirect_to course_evaluations_grades_path(:course_id => @grade.course_id, :course_evaluation_id => @grade.course_evaluation_id)
    else
      @evaluation = CourseEvaluation.find(params[:course_evaluation_id])
      @users = User.where(:id => @grade.user_id )
      render :action => 'edit'
    end
  end

  def delete
    @grade = Grade.find(params[:id])
    @grade.destroy
    redirect_to course_evaluations_grades_path(:course_id => params[:course_id], :course_evaluation_id => params[:course_evaluation_id])
  end

  def alternative_evaluate
    @grade = Grade.find(params[:id])
    @evaluation = CourseEvaluation.find(@grade.course_evaluation_id)
    @course = Course.find(@evaluation.course_id)
    @user = User.find(@grade.user_id)
    @questionnaire = CourseEvaluationQuestionnaire.where(:evaluation_id => @evaluation.id).first
    @user_evaluation = CourseUserEvaluation.where(:course_id => @course.id, :course_evaluation_questionnaire_id => @questionnaire.id, :user_id => @user.id).first
  end

  def save_alternative_evaluation
    params.permit!
    @grade = Grade.find(params[:id])
    @evaluation = CourseEvaluation.find(@grade.course_evaluation_id)
    @course = Course.find(@evaluation.course_id)
    @user = User.find(@grade.user_id)
    @questionnaire = CourseEvaluationQuestionnaire.where(:evaluation_id => @evaluation.id).first
    @user_evaluation = CourseUserEvaluation.where(:course_id => @course.id, :course_evaluation_questionnaire_id => @questionnaire.id, :user_id => @user.id).first
    @module_item_user = ModuleItemsUsers.where(:module_item_id => @evaluation.module_item_id, :user_id => @user.id).first
    grade = params[:grade][:grade]
    @grade.update_attribute(:grade, grade)
    redirect_to course_evaluations_grades_path(:course_id => @course.id, :course_evaluation_id => @evaluation.id)
  end

  def evaluate_file
    @grade = Grade.find(params[:id])
    @evaluation = CourseEvaluation.find(@grade.course_evaluation_id)
    @course = Course.find(@evaluation.course_id)
    @user = User.find(@grade.user_id)
    @module_item_user = ModuleItemsUsers.where(:module_item_id => @evaluation.module_item_id, :user_id => @user.id).first
  end

  def save_file_evaluation
    params.permit!
    @grade = Grade.find(params[:id])
    @evaluation = CourseEvaluation.find(@grade.course_evaluation_id)
    @course = Course.find(@evaluation.course_id)
    @user = User.find(@grade.user_id)
    @user_evaluation = CourseUserEvaluation.where(:course_id => @course.id, :module_item_id => @evaluation.module_item_id, :user_id => @user.id).first
    @module_item_user = ModuleItemsUsers.where(:module_item_id => @evaluation.module_item_id, :user_id => @user.id).first
    grade = params[:grade][:grade]
    @grade.update_attribute(:grade, grade)
    redirect_to course_evaluations_grades_path(:course_id => @course.id, :course_evaluation_id => @evaluation.id)
  end
end
