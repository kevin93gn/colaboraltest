class SessionsController < ApplicationController

  before_filter :coach_only, except: [:sessions_coachee, :show]


  def index
    @coaching = Coaching.find(params[:coaching_id])
    @sessions = CoachingSession.where(:coaching_id => @coaching.id)
    @next_sessions = CoachingSession.where(:coaching_id => @coaching.id).where("date >= ?", DateTime.now).order('date ASC').limit(10)

  end

  def coach_sessions
    @coaching = Coaching.find(params[:coaching_id])
    @coachee = User.find(params[:coachee_id])
    @sessions = CoachingSession.where(:coaching_id => @coaching.id, :user_id => params[:coachee_id])
  end

  def sessions_coachee
    @per_page = 10
    @coaching = Coaching.find(params[:coaching_id])
    @coachee = User.find(current_user.id)
    @sessions = CoachingSession.where(:coaching_id => @coaching.id, :user_id => @coachee.id).order('date ASC').paginate(page: params[:page], per_page: @per_page)
  end

  def new
    @session = CoachingSession.new
    @session.coaching_id = params[:coaching_id]
    @coachees  = User.joins('RIGHT JOIN coachees ON coachees.user_id = users.id')
                           .where(:coachees => {:coaching_id => @session.coaching_id})
                           .order('last_name asc')
  end

  def create
    params.permit!
    @session = CoachingSession.new(params[:coaching_session])
    @session.coaching_id = params[:coaching_id]
    if @session.save
      redirect_to sessions_path(:coaching_id => @session.coaching_id)
    else
      @coachees  = User.joins('RIGHT JOIN coachees ON coachees.user_id = users.id')
                       .where(:coachees => {:coaching_id => @session.coaching_id})
                       .order('last_name asc')
      render :action => 'new'
    end
  end

  def show
    @coaching = Coaching.find(params[:coaching_id])
    @session = CoachingSession.find(params[:id])
  end

  def edit
    @session = CoachingSession.find(params[:id])
    @coachees  = User.joins('RIGHT JOIN coachees ON coachees.user_id = users.id')
                     .where(:coachees => {:coaching_id => @session.coaching_id})
                     .order('last_name asc')
  end

  def update
    params.permit!
    @session = CoachingSession.find(params[:id])
    @session.update_attributes(params[:coaching_session])
    @coachees  = User.joins('RIGHT JOIN coachees ON coachees.user_id = users.id')
                     .where(:coachees => {:coaching_id => @session.coaching_id})
                     .order('last_name asc')
    render :action => 'edit'
  end

  def delete
    @session = CoachingSession.find(params[:id])
    coaching_id = @session.coaching_id
    @session.destroy
    redirect_to coaching_sessions_path(:coaching_id => coaching_id)
  end

end
