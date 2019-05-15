class CoursesController < ApplicationController

  before_filter :teacher_only, only: [:new, :create, :edit, :update]

  def index
    @courses = Course.where(:publish => true).order('id asc')
    unless current_user.admin?
      subscription = Subscription.where(:user_id => current_user.id)
      @course_subscription_ids =     subscription.map(&:course_id)
    end
  end

  def all
    @courses = Course.where(:publish => true).order('id asc')
    unless current_user.admin?
      subscription = Subscription.where(:user_id => current_user.id)
      @course_subscription_ids =     subscription.map(&:course_id)
    end

  end

  def finished
    @courses = Course.where(:publish => true).order('id asc')
    unless current_user.admin?
      subscription = Subscription.where(:user_id => current_user.id)
      @course_subscription_ids =     subscription.map(&:course_id)
    end
  end

  def show
    @course = Course.find(params[:id])
    unless @course.nil? and (!@course.all_subscribed and subscription.nil?)
      #@modules = ModuleItem.joins('RIGHT JOIN module_items_users ON module_item_id = module_item.id').where(:user_id => current_user.id).order('job_interviews.id desc')
      @teacher = User.find(@course.teacher_id)
      @item_count = @course.module_items.count
      @complete_items = ModuleItemsUsers.where(:course_id => @course.id, :user_id => current_user.id, :status => 'true').count
      @user_evaluation = UserEvaluation.where(:course_id => @course.id, :user_id => current_user.id).first
      @activities = Activity.where(['course_id = ? AND date >= ?', @course.id, DateTime.current]).order('date asc').limit(3)
      #@grades = Grade.where(:user_id => current_user.id, :course_id => @course.id).where('grade > 0')
      @grades = Grade.joins('RIGHT JOIN course_evaluations ON course_evaluation_id = course_evaluations.id AND grades_visible = true').where(:user_id => current_user.id, :course_id => @course.id).where('grade > 0')
      if @item_count > 0
        @course_completion = ( @complete_items.to_f / @item_count.to_f)*100
      end
    end
  end

  def new
    @course = Course.new
    @teachers = Array.new
    if current_user.teacher?
      current_user.first_name = "#{current_user.first_name} #{current_user.last_name}"
      @teachers.push(current_user)
    elsif
      User.where("role = 'administrador' OR role = 'profesor'").each do |teacher|
        teacher.first_name = "#{teacher.first_name} #{teacher.last_name}"
        @teachers.push(teacher)
      end
    end

  end

  def create
    params.permit!
    @course = Course.new(params[:course])
    @course.creator_id = current_user.id
    forum = Forum.first
    if @course.save
      if forum.nil?
        r = Random.new
        short_name = "iv#{r.rand(10...99)}#{@course.created_at.to_formatted_s(:number)}"
        forum = Forum.create(:identifier => short_name)
        if forum.save
          disqus = DisqusApi.v3.post('forums/create.json', website: "https://disqus.com/api/3.0/forums/create.json", name: 'IndoVirtual', short_name: short_name )
          @course.update_attribute(:forum, short_name)
        end
      else
        @course.update_attribute(:forum, forum.identifier)
      end
      redirect_to courses_admin_list_path
    else
      @teachers = Array.new
      User.where("role = 'administrador' OR role = 'profesor'").each do |teacher|
        teacher.first_name = "#{teacher.first_name} #{teacher.last_name}"
        @teachers.push(teacher)
      end
      render :action => 'new'
    end

  end

  def edit
    @course = Course.find(params[:id])
    if @course.nil?
      redirect_to root_path
    end
    @teachers = Array.new
    User.where("role = 'administrador' OR role = 'profesor'").each do |teacher|
      teacher.first_name = "#{teacher.first_name} #{teacher.last_name}"
      @teachers.push(teacher)
    end
    @creator_name = User.find(@course.creator_id)
    @creator_name = "#{@creator_name.first_name} #{@creator_name.last_name}"
  end

  def update
    params.permit!
    @course = Course.find(params[:course][:id])
    @course.update_attributes(params[:course])
    @creator_name = User.find(@course.creator_id)
    @creator_name = "#{@creator_name.first_name} #{@creator_name.last_name}"
    @teachers = Array.new
    User.where("role = 'administrador' OR role = 'profesor'").each do |teacher|
      teacher.first_name = "#{teacher.first_name} #{teacher.last_name}"
      @teachers.push(teacher)
    end
    render :action => 'edit'
  end

  def calendar
    #@activities = Activity.where(:course_id => params[:course_id]).order('date asc')
    @activities = Activity.where(['course_id = ? AND date >= ?', params[:course_id], DateTime.current]).order('date asc').limit(3)

  end

  def activity_detail
    @activity = Activity.find(params[:activity_id])
    @course = Course.find(params[:course_id])
  end

  #Courses Administration

  def courses_admin
    @per_page = 10
    if current_user.admin?
      @courses = Course.order('id desc').paginate(page: params[:page], per_page: @per_page)
    elsif current_user.teacher?
      @courses = Course.where(:teacher_id => current_user.id).order('id desc').paginate(page: params[:page], per_page: @per_page)
    else
      redirect_to root_path
    end
  end

  def delete
    course = Course.find(params[:id])
    if course
      course_module = CourseModule.where(:course_id => course.id)
      course_module.each do |c|
        item = ModuleItem.where(:course_module_id => c.id)
        item.each do |i|
          user_advance = ModuleItemsUsers.where(:module_item_id => i.id).first
          if user_advance
            user_advance.destroy
          end
          i.remove_data!
          i.destroy
        end
        c.destroy
      end
      course.destroy
      redirect_to courses_admin_list_path
    else
      redirect_to root_path
    end
  end

  def members
    @per_page = 50
    @course_id = params[:id]
    @users = User.joins('RIGHT JOIN subscriptions ON subscriptions.user_id = users.id')
                 .where(:subscriptions => {:course_id => @course_id}).order('last_name asc')
                 .paginate(page: params[:page], per_page: @per_page)
  end

  def add_members
    @per_page = 50
    @course_id = params[:id]
    @name = params[:name].to_s
    @institution = params[:institution].to_s
    @branch = params[:branch].to_s

=begin
    if flash[:name] and @name != ''
      @name = flash[:name]
    end
    if flash[:institution] and @institution  != ''
      @institution = flash[:institution]
    end
    if flash[:branch] and @branch != ''
      @branch = flash[:branch]
    end
=end
    @added_users = User.joins('RIGHT JOIN subscriptions ON subscriptions.user_id = users.id')
                       .where(:subscriptions => {:course_id => @course_id})
                       .count

    @users = User.where.not(:role => 'administrador')
                 .where("users.id NOT IN( SELECT user_id FROM subscriptions WHERE course_id = #{@course_id})")
                 .order('last_name asc').paginate(page: params[:page], per_page: @per_page)
    if !@name.nil? and @name != ''
      @users = @users.where("first_name ILIKE ? OR last_name ILIKE ?", "%#{@name}%", "%#{@name}%").order('role, id desc').paginate(page: params[:page], per_page: 10000)
      flash[:name] = @name
    end
    if !@institution.nil? and @institution != ''
      @users = @users.where("institution ILIKE ?", "%#{@institution}%").order('role, id desc').paginate(page: params[:page], per_page: 10000)
      flash[:institution] = @institution
    end
    if !@branch.nil? and @branch != ''
      @users = @users.where("branch ILIKE ?", "%#{@branch}%").order('role, id desc').paginate(page: params[:page], per_page: 10000)
      flash[:branch] = @branch
    end
  end

  def update_members
    @users = User.find(params[:user_ids])
    course_id = params[:id]

    @users.each do |user|
      s = Subscription.new
      s.user_id = user.id
      s.course_id = course_id
      s.save
    end
    redirect_to create_subscriptions_path(:id => course_id)
  end

  def remove_members
    @users = User.find(params[:user_ids])
    course_id = params[:id]

    @users.each do |user|
      s = Subscription.where(:user_id => user.id, :course_id => course_id).first
      s.destroy
    end
    redirect_to members_path(:id => course_id)
  end

  def activities
    @activities = Activity.where(:course_id => params[:course_id]).order('date asc').paginate(page: params[:page], per_page: 10)
  end

  def new_activity
    @course = Course.find(params[:course_id])
    @activity = Activity.new
  end

  def create_activity
    params.permit!
    course_id = params[:course_id]
    activity = Activity.new(params[:activity])
    activity.course_id = course_id
    activity.save
    redirect_to activities_path(:course_id => course_id)
  end

  def edit_activity
    @activity = Activity.find(params[:id])
  end

  def update_activity
    params.permit!
    @activity = Activity.find(params[:id])
    @activity.update_attributes(params[:activity])
    redirect_to activities_path(:course_id => @activity.course_id)
  end

  def delete_activity
    activity = Activity.find(params[:id])
    course_id = activity.course_id
    activity.destroy
    redirect_to activities_path(:course_id => course_id)

  end

end
