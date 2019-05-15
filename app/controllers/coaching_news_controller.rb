class CoachingNewsController < ApplicationController

  before_filter :coach_only, except: [:show, :coachee_news]


  def index
    @per_page = 7
    @coaching = Coaching.find(params[:coaching_id])
    @coaching_news = CoachingNews.where(:coaching_id => @coaching.id).order('created_at DESC').paginate(page: params[:page], per_page: @per_page)
  end

  def coachee_news
    @coaching = Coaching.find(params[:coaching_id])
    @news = CoachingNews.where(:coaching_id => @coaching.id).order('created_at DESC').paginate(page: params[:page], per_page: @per_page)
  end

  def new
    @coaching = Coaching.find(params[:coaching_id])
    @news = CoachingNews.new
    @news.coaching_id = @coaching.id
  end

  def show
    @coaching = Coaching.find(params[:coaching_id])
    @news = CoachingNews.find(params[:id])
  end

  def create
    params.permit!
    @news = CoachingNews.new(params[:coaching_news])
    @news.coaching_id = params[:coaching_id]
    @news.user_id = current_user.id
    if @news.save
      redirect_to news_path(:coaching_id => @news.coaching_id)
    else
      render :action => 'new'
    end
  end

  def edit
    @news = CoachingNews.find(params[:id])
    @coaching = Coaching.find(params[:coaching_id])
  end

  def update
    params.permit!
    @news = CoachingNews.find(params[:id])
    @coaching = Coaching.find(params[:coaching_id])
    @news.update_attributes(params[:coaching_news])
    render :action => 'edit'
  end

  def delete
    news = CoachingNews.find(params[:id])
    news.destroy
    redirect_to news_path(:coaching_id => params[:coaching_id])
  end


end
