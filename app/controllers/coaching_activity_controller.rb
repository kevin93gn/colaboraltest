class CoachingActivityController < ApplicationController

    before_filter :coach_only, except: [:sessions_coachee, :show]


    def index
      @coaching = Coaching.find(params[:coaching_id])
      @activities = CoachingActivity.where(:coaching_id => @coaching.id).order('date ASC')
      @next_activities = CoachingActivity.where(:coaching_id => @coaching.id).where("date >= ?", DateTime.now).order('date ASC').limit(10)

    end

    def coach_sessions
      @coaching = Coaching.find(params[:coaching_id])
      @coachee = User.find(params[:coachee_id])
      @activitys = CoachingActivity.where(:coaching_id => @coaching.id, :user_id => params[:coachee_id])
    end

    def sessions_coachee
      @per_page = 10
      @coaching = Coaching.find(params[:coaching_id])
      @coachee = User.find(current_user.id)
      @activitys = CoachingActivity.where(:coaching_id => @coaching.id, :user_id => @coachee.id).order('date ASC').paginate(page: params[:page], per_page: @per_page)
    end

    def new
      @activity = CoachingActivity.new
      @activity.coaching_id = params[:coaching_id]
      @users = User.where.not(:role => 'administrador')
                   .where.not(:role => 'coach')
                   .where("users.id IN( SELECT user_id FROM coachees WHERE coaching_id = #{@activity.coaching_id})")
                   .order('last_name asc')
                   .paginate(page: params[:page], per_page: @per_page)
    end

    def create
      params.permit!
      @activity = CoachingActivity.new(params[:coaching_activity])
      @activity.coaching_id = params[:coaching_id]
      if @activity.save
        redirect_to coaching_activities_path(:coaching_id => @activity.coaching_id)
      else
        @users = User.where.not(:role => 'administrador')
                     .where.not(:role => 'coach')
                     .where("users.id IN( SELECT user_id FROM coachees WHERE coaching_id = #{@activity.coaching_id})")
                     .order('last_name asc')
                     .paginate(page: params[:page], per_page: @per_page)
        render :action => 'new'
      end
    end

    def show
      @coaching = Coaching.find(params[:coaching_id])
      @activity = CoachingActivity.find(params[:id])
    end

    def edit
      @activity = CoachingActivity.find(params[:id])
      @users = User.where.not(:role => 'administrador')
                   .where.not(:role => 'coach')
                   .where("users.id IN( SELECT user_id FROM coachees WHERE coaching_id = #{@activity.coaching_id})")
                   .order('last_name asc')
                   .paginate(page: params[:page], per_page: @per_page)
    end

    def update
      params.permit!
      @activity = CoachingActivity.find(params[:id])
      @activity.update_attributes(params[:coaching_activity])
      @users = User.where.not(:role => 'administrador')
                   .where.not(:role => 'coach')
                   .where("users.id IN( SELECT user_id FROM coachees WHERE coaching_id = #{@activity.coaching_id})")
                   .order('last_name asc')
                   .paginate(page: params[:page], per_page: @per_page)
      redirect_to coaching_activities_path(:coaching_id => @activity.coaching_id)
    end

    def delete
      @activity = CoachingActivity.find(params[:id])
      coaching_id = @activity.coaching_id
      @activity.destroy
      redirect_to coaching_activities_path(:coaching_id => @activity.coaching_id)
    end


end
