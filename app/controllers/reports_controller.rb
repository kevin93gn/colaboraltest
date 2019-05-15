class ReportsController < ApplicationController

  before_filter :admin_only, only: [:new, :create, :edit, :update, :courses_admin]

  def course
    @per_page = 800
    @page = params[:page]
    @course = Course.find(params[:course_id])
    @users_who_completed_the_course = 0
    @users_who_havent_initiated_the_course = 0
    @course_item_count = @course.module_items.count
    @completed_30_percent = 0
    @completed_50_percent = 0
    @completed_70_percent = 0

    @users = get_course_users(@course).paginate(page: params[:page], per_page: @per_page)
    @user_count = @users.count
    @item_completion_by_user = Hash.new
    @item_visits_by_user = Hash.new
    @items_viewed_by_user = Hash.new

    for user in @users
      user_items = ModuleItemsUsers.where(:course_id => @course.id, :user_id => user.id).order('id')
      user_complete_items = ModuleItemsUsers.where(:course_id => @course.id, :user_id => user.id, :status => 'true').count
      @item_completion_by_user[user.id] = user_complete_items
      @item_visits_by_user[user.id] = 0
      user_items.each do |ui|
        if ui.visits.nil?
          ui.visits = 0
        end
        @item_visits_by_user[user.id] = ui.visits + @item_visits_by_user[user.id]
      end
      @items_viewed_by_user[user.id] = user_items.count
      @users_who_completed_the_course += 1 if @course_item_count == user_complete_items
      @users_who_havent_initiated_the_course += 1 if user_complete_items == 0
      @completed_30_percent += 1 if (@course_item_count * 0.30) < user_complete_items
      @completed_50_percent += 1 if (@course_item_count * 0.50) < user_complete_items
      @completed_70_percent += 1 if (@course_item_count * 0.70) < user_complete_items
    end
    respond_to do |format|
      format.html
      format.xlsx {render xlsx: 'download_course', template: 'reports/download_course', filename: "Reporte #{@course.name}.xlsx", page:@page}
    end
  end

  def select_user_advance
    @user = User.new
    @course = Course.find(params[:course_id])
    @users = Array.new
    get_course_users(@course).each do |user|
      user.first_name = "#{user.first_name} #{user.last_name}"
      @users.push(user)
    end
  end

  def select_user_advance_redirection
    redirect_to user_advance_report_path(:course_id => params[:course_id], :user_id => params[:user][:id])
  end

  def user_advance
    @course = Course.find(params[:course_id])
    @user = User.find(params[:user_id])
    unless @course.nil?
      #@modules = ModuleItem.joins('RIGHT JOIN module_items_users ON module_item_id = module_item.id').where(:user_id => current_user.id).order('job_interviews.id desc')
      @item_count = @course.module_items.count
      @complete_items = ModuleItemsUsers.where(:course_id => @course.id, :user_id => current_user.id, :status => 'true').count
      if @item_count > 0
        @course_completion = ( @complete_items.to_f / @item_count.to_f)*100
      end
    else
      redirect_to root
    end
  end

  def get_course_users(course)
    if course.all_subscribed
      users =  User.joins('RIGHT JOIN module_items_users ON module_items_users.user_id = users.id')
                   .where(:role => 'usuario', :module_items_users => {:course_id => course.id}).order('last_name asc')
                   .distinct

    else
      users = User.joins('RIGHT JOIN subscriptions ON subscriptions.user_id = users.id')
                  .where(:subscriptions => {:course_id => course.id}).order('last_name asc')
    end
  end


  #Coachings

  def goals
    @coaching = Coaching.find(params[:coaching_id])
    get_coaching_users(@coaching.id)
    @goals_count = Goal.where(:coaching_id => @coaching.id).count

    @user_count = @users.count
    @completed_goals_by_user = Hash.new
    @not_completed_goals_by_user = Hash.new
    @pending_goals_by_user = Hash.new
    @status_by_user = Hash.new
    @completion_porcentage_by_user  = Hash.new
    @users_without_not_completed_goals = 0
    @users.each do |user|
      coachee_goals = CoacheeGoal.where(:coaching_id => @coaching.id, :user_id => user.id)
      completed_goals = 0
      not_completed_goals = 0
      pending_goals = 0
      completion_percentage = 0

      coachee_goals.each do |cg|
        if cg.completed == true
          completed_goals = completed_goals + 1
          completion_percentage = completion_percentage + cg.goal.percentage
        elsif cg.goal.end_date < DateTime.now
          not_completed_goals = not_completed_goals + 1
        else
          pending_goals = pending_goals + 1
        end
      end
      @completed_goals_by_user[user.id] = completed_goals
      @not_completed_goals_by_user[user.id] = not_completed_goals
      @pending_goals_by_user[user.id] = pending_goals
      @completion_porcentage_by_user[user.id] = completion_percentage

      if not_completed_goals > 0
        @status_by_user[user.id] = 'Atrasado'
      else
        @status_by_user[user.id] = 'OK'
        @users_without_not_completed_goals = @users_without_not_completed_goals + 1
      end
    end
  end
  def get_coaching_users(coaching_id)
      @users = User.joins('RIGHT JOIN coachees ON coachees.user_id = users.id')
                   .where(:coachees => {:coaching_id => @coaching.id})
                   .order('last_name asc')
  end
end
