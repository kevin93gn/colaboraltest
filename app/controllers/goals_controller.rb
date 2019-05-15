
class GoalsController < ApplicationController

  before_filter :coach_only, except: [:show, :new, :create, :edit, :delete, :update]
  
  include GoalsHelper

  def subfactors
    @subfactors = ['Branding personal', 'Prospección', 'Ofertas de trabajo', 'Mi Curriculum']
  end

  def index
    @coaching = Coaching.find(params[:coaching_id])
    @goals = Goal.where(:coaching_id => @coaching.id, :is_global => true).order('id ASC')
  end

  def show
    @coaching = Coaching.find(params[:coaching_id])
    @coach = @coaching.user
    @pdi = Coachee.where(:coaching_id => @coaching.id, :user_id => current_user.id).first.pdi
    subfactors
    @coachee_goals = CoacheeGoal.where(:coaching_id => @coaching.id, :user_id => current_user.id)
                                .joins('LEFT JOIN goals ON coachee_goals.goal_id = goals.id')
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
  end

  def new
    @goal = Goal.new
    subfactors
    @goal.coaching_id = params[:coaching_id]
    if current_user.user?
      @coachee = current_user
    elsif !params[:user_id].nil?
      @coachee = User.find(params[:user_id])
    else
      flash[:percentage_error] = nil
    end
  end

  def create
    params.permit!
    validation = true
    @goal = Goal.new(params[:goal])
    @goal.coaching_id = params[:coaching_id]

    if params[:user_id].nil?
      @goal.is_global = true
    else
      @coachee = User.find(params[:user_id])
      max_value = coachee_max_value_for_percentage(@goal.coaching_id, params[:user_id], 0)
      if !@goal.percentage.nil? #and max_value >= @goal.percentage
        @goal.is_global = false
        @goal.user_id = @coachee.id
      else
=begin
        flash[:percentage_error] = "El porcentaje no puede sobrepasar 100% sumando todas las metas, el valor maximo para el campo es #{max_value}%"
        subfactors
        params[:user_id] = @coachee.id
        validation = false
=end
      end
    end
    if validation and @goal.save
      @coachees = Coachee.where(:coaching_id => @goal.coaching_id)
      if @goal.is_global
        @coachees.each do |c|
          CoacheeGoal.create(:user_id => c.user_id, :goal_id => @goal.id, :coaching_id => @goal.coaching_id , :completed => false)
        end
        redirect_to goals_path(:coaching_id => @goal.coaching_id)
      else
        CoacheeGoal.create(:user_id => @goal.user_id, :goal_id => @goal.id, :coaching_id => @goal.coaching_id , :completed => false)
        redirect_to coachee_goals_path(:coaching_id => @goal.coaching_id, :coachee_id => @coachee.id)
      end
    else
      subfactors
      render :action => 'new'
    end
  end

  def edit
    @goal = Goal.find(params[:id])
    unless params[:user_id].nil?
      @coachee = User.find(params[:user_id])
    else
      flash[:percentage_error] = nil
    end
    subfactors
  end

  def update
      params.permit!
      @goal = Goal.find(params[:id])
      validation = true

      if !params[:user_id].nil?
        @coachee = User.find(params[:user_id])
        params[:user_id] = @coachee.id
        max_value = coachee_max_value_for_percentage(@goal.coaching_id, @coachee.id, @goal.id)
        if !@goal.percentage.nil? #and max_value < @goal.percentage
=begin
          flash[:percentage_error] = "El porcentaje no puede sobrepasar 100% sumando todas las metas, el valor maximo para el campo es #{max_value}%"
          params[:user_id] = @coachee.id
          validation = false
=end
        end
      end
      if validation
        @goal.update_attributes(params[:goal])
      end
      subfactors
      render :action => 'edit'
  end

  def coachee_goals
    @coaching = Coaching.find(params[:coaching_id])
    @coachee = User.find(params[:coachee_id])
    @coachee_goals = CoacheeGoal.where(:coaching_id => @coaching.id, :user_id => params[:coachee_id]).order('goal_id ASC')
  end

  def update_coachee_goals
    unless params[:goals_ids].nil?
      selected_goals = Goal.find(params[:goals_ids])
    else
      selected_goals = Array.new
    end
    coachee_id = params[:coachee_id]
    coaching_id = params[:coaching_id]
    goals = Goal.where(:coaching_id => coaching_id)
    goals.each do |goal|

      coachee_goal = CoacheeGoal.where(:user_id => coachee_id, :goal_id => goal.id).first

      if selected_goals.include?(goal) and !coachee_goal.nil?
        coachee_goal.update_attribute(:completed, true)
      else
        unless coachee_goal.nil?
        coachee_goal.update_attribute(:completed, false)
          end
      end
    end
    redirect_to coachee_goals_path(:coaching_id => coaching_id)
  end

  def delete
    goal = Goal.find(params[:id])
    coaching_id = goal.coaching_id
    unless goal.nil?
      coachee_goals = CoacheeGoal.where(:goal_id => goal.id, :coaching_id => coaching_id)
      coachee_goals.each do |cg|
        cg.destroy
      end
      goal.destroy
    end
    if params[:user_id].nil?
      redirect_to goals_path(:coaching_id => coaching_id)
    else
      redirect_to coachee_goals_path(:coaching_id => coaching_id, :coachee_id => params[:user_id])
    end
  end


end
