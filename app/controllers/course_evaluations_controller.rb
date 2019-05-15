class CourseEvaluationsController < ApplicationController

  def index
    @course_id =  params[:course_id]
    @course_evaluations = CourseEvaluation.where(:course_id => @course_id).order('created_at ASC')
  end

  def new
    @course_evaluation = CourseEvaluation.new
    @course = Course.find(params[:course_id])
    @course_evaluation.course_id = @course.id
    @module_items = ModuleItem
                    .where(:course_id => @course.id).where("course_id = #{@course.id} AND id NOT in (SELECT module_item_id FROM course_evaluations WHERE course_id = #{@course.id} AND module_item_id is not null)")
                    .order('module_items.id asc')
  end

  def create
    params.permit!
    @course_evaluation = CourseEvaluation.new(params[:course_evaluation])
    @course = Course.find(params[:course_id])
    @course_evaluation.course_id = @course.id
    error = false
    kind = params[:kind]
    if !kind.nil?
      if kind == 'alternatives'
        @course_evaluation.kind = 'Alternatives'
        @course_evaluation.user_upload_expected = false
      elsif kind == 'upload'
        @course_evaluation.kind = 'Upload Test'
        @course_evaluation.user_upload_expected = true
      elsif kind == 'manual'
        @course_evaluation.kind = 'Manual'
        @course_evaluation.user_upload_expected = false
      end
      if kind == 'alternatives' or kind == 'upload'
        if @course_evaluation.module_item_id.nil?
          error = true
        end
      end
    else
      @course_evaluation.kind = 'Uploaded By Teacher'
      @course_evaluation.user_upload_expected = false
    end
    if !error and @course_evaluation.save
      redirect_to course_evaluations_path
    else
      @module_items = ModuleItem
                      .where(:course_id => @course.id).where("course_id = #{@course.id} AND id NOT in (SELECT module_item_id FROM course_evaluations WHERE course_id = #{@course.id} AND module_item_id is not null)")
                      .order('module_items.id asc')
      render :action => 'new'
    end
  end

  def edit
    @course_evaluation = CourseEvaluation.find(params[:id])
    @course = Course.find(params[:course_id])
    @module_items = ModuleItem
                    .where(:course_id => @course.id).where("course_id = #{@course.id} AND id NOT in (SELECT module_item_id FROM course_evaluations WHERE course_id = #{@course.id} AND module_item_id is not null)")
                    .order('module_items.id asc')
  end

  def update
    params.permit!
    @course_evaluation = CourseEvaluation.find(params[:id])
    @course = Course.find(params[:course_id])
    if @course_evaluation.update_attributes(:name => params[:course_evaluation][:name], :visible => params[:course_evaluation][:visible], :grades_visible => params[:course_evaluation][:grades_visible])
      redirect_to course_evaluations_path
    else
      @module_items = ModuleItem
                      .where(:course_id => @course.id).where("course_id = #{@course.id} AND id NOT in (SELECT module_item_id FROM course_evaluations WHERE course_id = #{@course.id} AND module_item_id is not null)")
                      .order('module_items.id asc')
      render :edit
    end
  end

  def import_grades
    @course_evaluation = CourseEvaluation.find(params[:id])
  end

  def create_import_grades
    @course_evaluation = CourseEvaluation.find(params[:id])
    users_with_grades = User.joins('RIGHT JOIN grades ON grades.user_id = users.id')
                            .where(:grades => {:course_evaluation_id => @course_evaluation.id}).pluck(:id)
    users_with_grades.push(0)
    users_list = User.joins('RIGHT JOIN subscriptions ON subscriptions.user_id = users.id')
                 .where(:subscriptions => {:course_id => @course_evaluation.course_id })
                 .where("users.id not in (?)", users_with_grades).pluck(:id)
    get_file =  params[:excelfile]
    File.open("#{Rails.root.join('tmp')}/grades.xls",  'wb') do |file|
      file.write(get_file.read)
    end
    errors = Array.new
    i = 1
    book = Spreadsheet.open "#{Rails.root.join('tmp')}/grades.xls"
    sheet1 = book.worksheet 0
    sheet1.each 1 do |row|
      unless row[0].nil? or row[1].nil?
        email = row[0].to_s
        email = email.downcase.encode('ASCII', :invalid => :replace, :undef => :replace).gsub("\u0000", '').gsub('?', '').gsub('mailto:', '')
        grade = row[1].round(1)
        user = User.where(:email => email).first
        if !user.nil? and user.id.in?(users_list)
          g = Grade.new(:grade => grade, :user_id => user.id, :course_evaluation_id => @course_evaluation.id, :course_id => @course_evaluation.course_id   )
          if g.save
            i=i+1
          else
            errors.push("Error de formato en la linea #{i}, email: #{email}")
            puts "Error en linea: #{i} mail: #{email}"
          end
          flash[:i] = i
          flash[:errors] = errors
        end
      end
    end
    redirect_to course_evaluations_grades_path(:course_evaluation_id => @course_evaluation.id,  :course_id => @course_evaluation.course_id )
  end

  def delete
    @course_evaluation = CourseEvaluation.find(params[:id])
    @questionnaire = CourseEvaluationQuestionnaire.where(:evaluation_id => @course_evaluation.id).first
    @course_user_evaluations = CourseUserEvaluation.where(:module_item_id => @course_evaluation.module_item_id)
    @module_items_users = ModuleItemsUsers.where(:module_item_id => @course_evaluation.module_item_id)
    @module_items_users.each do |miu|
      miu.update_attribute(:sent, false)
      miu.update_attribute(:evaluation_file, '')
    end
    unless @questionnaire.nil?
      @questionnaire.course_evaluation_questions.each do |q|
        q.course_evaluation_question_alternatives.each do |qa|
          qa.destroy
        end
        q.destroy
      end
      @questionnaire.destroy
    end
    @course_evaluation.grades.each do |g|
      g.destroy
    end
    @course_user_evaluations.each do |cue|
      answers = CourseEvaluationAnswer.where(:course_user_evaluation_id => cue.id)
      answers.each do |a|
        a.destroy
      end
      cue.destroy
    end

    @course_evaluation.destroy
    redirect_to course_evaluations_path
  end
end