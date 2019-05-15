class JobOffersController < ApplicationController
  
  def index
    @per_page = 10
    @coaching = Coaching.find(params[:coaching_id])
    @job_offers = JobOffer.where(:coaching_id => @coaching.id, :user_id => [nil, current_user.id]).order('created_at DESC').paginate(page: params[:page], per_page: @per_page)
  end

  def admin
    @per_page = 10
    user_id = params[:user_id]
    @coaching = Coaching.find(params[:coaching_id])
    if user_id.nil?
      @job_offers = JobOffer.where(:coaching_id => @coaching.id).order('created_at DESC').paginate(page: params[:page], per_page: @per_page)
    elsif
    @user = User.find(user_id)
      unless @user.nil?
        @job_offers = JobOffer.where(:coaching_id => @coaching.id, :user_id => user_id).order('created_at DESC').paginate(page: params[:page], per_page: @per_page)
      end
    end  end

  def new
    user_id = params[:user_id]
    unless user_id.nil?
      @user = User.find(user_id)
    end
    @coaching = Coaching.find(params[:coaching_id])
    @job_offer = JobOffer.new
    @job_offer.coaching_id = @coaching.id
  end

  def create
    params.permit!
    @job_offer = JobOffer.new(params[:job_offer])
    @job_offer.coaching_id = params[:coaching_id]
    if @job_offer.save
      if @job_offer.user.nil?
        redirect_to job_offers_admin_path(:coaching_id => @job_offer.coaching_id)
      else
        redirect_to job_offers_admin_path(:coaching_id => @job_offer.coaching_id, :user_id => @job_offer.user.id )
      end
    else
      @coaching = Coaching.find(params[:coaching_id])
      render :action => 'new'
    end
  end

  def edit
    @job_offer = JobOffer.find(params[:id])
    @coaching = Coaching.find(params[:coaching_id])
  end

  def update
    params.permit!
    @job_offer = JobOffer.find(params[:id])
    @coaching = Coaching.find(params[:coaching_id])
    if @job_offer.update_attributes(params[:job_offer])
      if @job_offer.user.nil?
        redirect_to job_offers_admin_path(:coaching_id => @job_offer.coaching_id)
      else
        redirect_to job_offers_admin_path(:coaching_id => @job_offer.coaching_id, :user_id => @job_offer.user.id )
      end
    else
      render :action => 'edit'
    end
  end

  def delete

    job_offer = JobOffer.find(params[:id])
    if job_offer.user.nil?
      job_offer.destroy
      redirect_to job_offers_admin_path(:coaching_id => params[:coaching_id])
    else
      user_id = job_offer.user.id
      job_offer.destroy
      redirect_to job_offers_admin_path(:coaching_id => params[:coaching_id], :user_id => user_id )
    end
  end
  
end
