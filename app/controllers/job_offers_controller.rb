class JobOffersController < ApplicationController
  
  def index
    @per_page = 10
    @coaching = Coaching.find(params[:coaching_id])
    @job_offers = JobOffer.where(:coaching_id => @coaching.id, :user_id => [nil, current_user.id]).order('created_at DESC')
  end

  def admin
    user_id = params[:user_id]
    @coaching = Coaching.find(params[:coaching_id])
    if user_id.nil?
      @job_offers = JobOffer.where(:coaching_id => @coaching.id).order('created_at DESC')
    elsif
    @user = User.find(user_id)
      unless @user.nil?
        @job_offers = JobOffer.where(:coaching_id => @coaching.id, :user_id => user_id).order('created_at DESC')
      end
    end  
  end

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
    @job_offer.status = 1
    unless params[:user_id].nil?
      @job_offer.user_id = params[:user_id]
    end
    if @job_offer.save
      if @job_offer.user.nil?
        redirect_to job_offers_admin_path(:coaching_id => @job_offer.coaching_id)
      else
        redirect_to job_offers_admin_path(:coaching_id => @job_offer.coaching_id, :user_id => @job_offer.user.id )
      end
    else
      @coaching = Coaching.find(params[:coaching_id])
      @user = User.find(params[:user_id])
      Rails.logger.error @job_offer.errors.to_json
      render :action => 'new', flash: :errors
    end
  end

  def edit
    @job_offer = JobOffer.find(params[:id])
    @coaching = Coaching.find(params[:coaching_id])
    
    unless @job_offer.user_id.nil? 
      @user = User.find(@job_offer.user_id)
    end
  end
  
    def change_status
    @job_offer = JobOffer.find(params[:id])
    respond_to do |format|
      if @job_offer.update(status: params[:status])
        format.html { redirect_to job_offers_admin_path(:coaching_id => params[:coaching_id]), notice: "Estatus de la oferta #{@job_offer.name} actualizada exitosamente" }
        format.json { render :show, status: :ok, location: @job_offer }
      else
        format.html { redirect_to job_offer_admin_path(:coaching_id => params[:coaching_id]), notice: "Falló al cambiar el estatus de la oferta #{@job_offer.name}" }
        format.json { render json: @job_offer.errors, status: :unprocessable_entity }
      end
    end
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

  def view_offer
    params.permit!
    @job_offer = JobOffer.find(params[:id])
    @coaching = Coaching.find(params[:coaching_id])
    if @job_offer.status == 1
      @job_offer.update_attributes(status: 2)
    end
    redirect_to :back
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

  def import
    @coaching = Coaching.find(params[:coaching_id])
    @coachee = User.find(params[:user_id])
  end

  def create_import
    get_file =  params[:excelfile]
    coaching_id = params[:coaching_id]
    unless params[:user_id].nil? 
      user_id = params[:user_id]
    end
    File.open("#{Rails.root.join('tmp')}/temp.xls",  'wb') do |file|
      file.write(get_file.read)
    end
    errors = []
    i = 1
    book = Spreadsheet.open "#{Rails.root.join('tmp')}/temp.xls"
    sheet1 = book.worksheet 0
    sheet1.each 1 do |row|
      source = row[0]
      name = row[2]
      description = row[3]
      url = row[4]
      if params[:user_id].nil? 
        u = JobOffer.new(source: source, name: name, description: description, url: url, coaching_id: coaching_id, status: 1)
      else
        u = JobOffer.new(source: source, name: name, description: description, url: url,coaching_id: coaching_id, user_id: user_id, status: 1)
      end
      unless u.save
        u.errors.each do |key, value|
          errors.push("Error en linea: #{i} Campo [#{key}] = #{value}")
        end
        puts "Error en linea: #{i} nombre: #{name}"
        Rails.logger.error u.errors.to_json
      end
      i += 1
    end
    3.times do 
      errors.pop
    end
    if errors.empty?
      notice = 'Carga completada sin problemas'
    else
      notice = errors
    end
    respond_to do |format|
      if params[:user_id].nil?
        format.html { redirect_to job_offers_admin_path(:coaching_id => coaching_id,notice: notice)}
      else
        format.html { redirect_to job_offers_admin_path(:coaching_id => params[:coaching_id], :user_id => params[:user_id],notice: notice)}
      end
    end
  end
end
