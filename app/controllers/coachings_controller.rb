class CoachingsController < ApplicationController

  before_filter :coach_only, only: [:new, :create, :edit, :update, :coaching_admin, :graph, :pdi]

  include GoalsHelper
  def index
    @coachings = Coaching.joins('RIGHT JOIN coachees ON coachees.coaching_id = coachings.id')
                         .where(:publish => true, :coachees => {:user_id => current_user.id})
    @courses = Course.joins('RIGHT JOIN subscriptions ON subscriptions.course_id = courses.id')
                     .where(:publish => true, :subscriptions => {:user_id => current_user.id})
    if params[:coaching_id].nil?
      @coaching = @coachings.first
    else
      @coaching = Coaching.find(params[:coaching_id])
    end
    unless @coaching.nil?
      @coach = User.find(@coaching.user_id)
      @goals = CoacheeGoal.where(:user_id => current_user.id, :coaching_id => @coaching.id).order('goal_id DESC').limit(5)
      @sessions = CoachingSession.where(:coaching_id => @coaching.id, :user_id => current_user.id).where("date >= ?", DateTime.now).order('date ASC').limit(4)
      @news = CoachingNews.where(:coaching_id => @coaching.id)
      @job_offers = JobOffer.where(:coaching_id => @coaching.id, :user_id => [nil, current_user.id]).order('created_at DESC')
      @all_sessions = CoachingSession.where(:coaching_id => @coaching.id, :user_id => current_user.id).count
      @graph = CoachingGraph.where(:user_id => current_user.id, :coaching_id => @coaching.id).first
      @pdi = Coachee.where(:coaching_id => @coaching.id, :user_id => current_user.id).first.pdi
      @activities = CoachingActivity.where(:coaching_id => @coaching.id).where("user_id = ? OR user_id IS NULL", current_user.id).order('date ASC')

      @coachee_goals = CoacheeGoal.where(:coaching_id => @coaching.id, :user_id => current_user.id).joins('RIGHT JOIN goals ON coachee_goals.goal_id = goals.id')
                            .order('goals.subfactor, completed ASC')

      @complete_items = CoacheeGoal.where(:coaching_id => @coaching.id, :user_id => current_user.id, :completed => 'true').count
      @coaching_completion = 0
      if @complete_items > 0
        @coaching_completion = (@complete_items.to_f / @coachee_goals.count) * 100
      end
=begin
      @coachee_goals.each do |cg|
        if cg.completed
          @coaching_completion = cg.goal.percentage + @coaching_completion
        end
      end
=end
a = 1
    end
  end

  def coaching_admin
    @per_page = 10
    if current_user.admin?
      @coachings = Coaching.order('id asc').paginate(page: params[:page], per_page: @per_page)
    elsif current_user.coach? or current_user.teacher?
      @coachings = Coaching.where(:user_id => current_user.id).order('id asc').paginate(page: params[:page], per_page: @per_page)
    else
      redirect_to root_path
    end
  end

  def new
    @coaching = Coaching.new
    @coachees = Array.new
    if current_user.admin?
      User.where("role = 'administrador' OR role = 'coach' OR role = 'profesor'").each do |coachee|
        coachee.first_name = "#{coachee.first_name} #{coachee.last_name}"
        @coachees.push(coachee)
      end
    elsif current_user.coach? or current_user.teacher?
      current_user.first_name = "#{current_user.first_name} #{current_user.last_name}"
      @coachees.push(current_user)
    end
  end

  def create
    params.permit!
    @coaching = Coaching.new(params[:coaching])
    @coaching.creator_id = current_user.id
    if @coaching.save
      redirect_to coaching_admin_path
    else
      @coachees = Array.new
      if current_user.admin?
        User.where("role = 'administrador' OR role = 'coach' OR role = 'profesor'").each do |coachee|
          coachee.first_name = "#{coachee.first_name} #{coachee.last_name}"
          @coachees.push(coachee)
        end
      elsif current_user.coach? or current_user.teacher?
        current_user.first_name = "#{current_user.first_name} #{current_user.last_name}"
        @coachees.push(current_user)
      end
      render :action => 'new'
    end
  end

  def edit
    @coaching = Coaching.find(params[:id])
    @coachees = Array.new
    if current_user.admin?
      User.where("role = 'administrador' OR role = 'coach' OR role = 'profesor'").each do |coachee|
        coachee.first_name = "#{coachee.first_name} #{coachee.last_name}"
        @coachees.push(coachee)
      end
    elsif current_user.coach? or current_user.teacher?
      current_user.first_name = "#{current_user.first_name} #{current_user.last_name}"
      @coachees.push(current_user)
    end
  end

  def update
    params.permit!
    @coaching = Coaching.find(params[:coaching][:id])
    @coaching.update_attributes(params[:coaching])
    @coachees = Array.new
    if current_user.admin?
      User.where("role = 'administrador' OR role = 'coach' OR role = 'profesor'").each do |coachee|
        coachee.first_name = "#{coachee.first_name} #{coachee.last_name}"
        @coachees.push(coachee)
      end
    elsif current_user.coach? or current_user.teacher?
      current_user.first_name = "#{current_user.first_name} #{current_user.last_name}"
      @coachees.push(current_user)
    end
    render :action => 'edit'
  end


  def coachees
    @per_page = 50
    @coaching = Coaching.find(params[:coaching_id])
    @users = User.joins('RIGHT JOIN coachees ON coachees.user_id = users.id')
                 .where(:coachees => {:coaching_id => @coaching.id})
                 .order('last_name asc')
                 .paginate(page: params[:page], per_page: @per_page)
  end

  def add_coachees
    @per_page = 50
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
    @coaching = Coaching.find(params[:coaching_id])
    @added_users = User.joins('RIGHT JOIN coachees ON coachees.user_id = users.id')
                       .where(:coachees => {:coaching_id => @coaching.id})
                       .count

    @users = User.where.not(:role => 'administrador')
                 .where.not(:role => 'coach')
                 .where("users.id NOT IN( SELECT user_id FROM coachees WHERE coaching_id = #{@coaching.id})")
                 .order('last_name asc')
                 .paginate(page: params[:page], per_page: @per_page)
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

  def update_coachees
    @users = User.find(params[:user_ids])
    coaching_id = params[:coaching_id]

    @users.each do |user|
      s = Coachee.new
      s.user_id = user.id
      s.coaching_id = coaching_id
      if s.save
        create_coachee_goals(coaching_id, s.user_id)
      end
    end
    flash[:name] = ''
    flash[:institution] = ''
    flash[:branch] = ''

    redirect_to add_coachees_path(:coaching_id => coaching_id, :institution => flash[:institution])
  end

  def remove_coachee
    @users = User.find(params[:user_ids])
    coaching_id = params[:coaching_id]
    @users.each do |user|
      s = Coachee.where(:user_id => user.id, :coaching_id => coaching_id).first
      s.destroy
    end
    redirect_to coachees_path(:coaching_id => coaching_id)
  end

  def graph
    @graph = CoachingGraph.where(:coaching_id => params[:coaching_id], :user_id => params[:coachee_id]).first
    if @graph.nil?
      @graph = CoachingGraph.create(:coaching_id => params[:coaching_id], :user_id => params[:coachee_id], :version => 1)
    end
  end

  def update_graph
    params.permit!
    @graph = CoachingGraph.find(params[:coaching_graph][:id])
    @graph.update_attributes(params[:coaching_graph])
    redirect_to coaching_graph_path(:coaching_id => @graph.coaching_id, :user_id => @graph.user_id)
  end

  def pdi
    @coachee = Coachee.where(:coaching_id => params[:id], :user_id => params[:coachee_id]).first
  end

  def update_pdi
    @coachee = Coachee.where(:coaching_id => params[:id], :user_id => params[:coachee_id]).first
    @coachee.update_attribute(:pdi, params[:coachee][:pdi])
    redirect_to coaching_pdi_path(:id => @coachee.coaching_id, :user_id => params[:coachee_id])
  end

  def delete
    coaching = Coaching.find(params[:id])
    unless coaching.nil?
      goals = Goal.where(:coaching_id => coaching.id)
      coachee_goals = CoacheeGoal.where(:coaching_id => coaching.id)
      sessions = CoachingSession.where(:coaching_id => coaching.id)
      news = CoachingNews.where(:coaching_id => coaching.id)
      coachees = Coachee.where(:coaching_id => coaching.id)
      graph = CoachingGraph.where(:coaching_id => coaching.id)

      goals.each do |g|
        g.destroy
      end
      sessions.each do |s|
        s.destroy
      end
      coachee_goals.each do |cg|
        cg.destroy
      end
      news.each do |n|
        n.destroy
      end
      coachees.each do |c|
        c.destroy
      end
      graph.each do |g|
        g.destroy
      end
      coaching.destroy
    end
    redirect_to coaching_admin_path
  end
end
