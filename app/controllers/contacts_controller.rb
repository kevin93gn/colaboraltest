class ContactsController < ApplicationController
  before_action :set_contact, only: [:show, :edit, :update, :destroy]

  # GET /contacts
  # GET /contacts.json
  def index
    @contacts = Contact.all
  end

  def admin
    user_id = params[:user_id]
    @coaching = Coaching.find(params[:coaching_id])
    unless user_id.present?
      @contacts = Contact.where(:coaching_id => @coaching.id).order('created_at DESC')
    else
    @user = User.find(user_id)
      unless @user.nil?
        @contacts = Contact.where(:coaching_id => @coaching.id, :user_id => user_id).order('created_at DESC')
      end
    end
  end

  def change_status
    @contact = Contact.find(params[:id])
    respond_to do |format|
      if @contact.update(status: params[:status])
        format.html { redirect_to contacts_admin_path(:coaching_id => params[:coaching_id]), notice: "Estatus del contacto #{@contact.email} actualizado exitosamente" }
        format.json { render :show, status: :ok, location: @contact }
      else
        format.html { redirect_to contacts_admin_path(:coaching_id => params[:coaching_id]), notice: "Falló al cambiar el estatus del contacto #{@contact.email}" }
        format.json { render json: @contact.errors, status: :unprocessable_entity }
      end
    end
  end

  # GET /contacts/1
  # GET /contacts/1.json
  def show
  end

  # GET /contacts/new
  def new
    @contact = Contact.new
    @coaching = Coaching.find(params[:coaching_id])
  end

  # GET /contacts/1/edit
  def edit
    @coaching = Coaching.find(params[:coaching_id])
  end


  def import
    @coaching = Coaching.find(params[:coaching_id])
  end

  def create_import
    get_file =  params[:excelfile]
    coaching_id = params[:coaching_id]
    File.open("#{Rails.root.join('tmp')}/temp.xls",  'wb') do |file|
      file.write(get_file.read)
    end
    errors = []
    i = 1
    book = Spreadsheet.open "#{Rails.root.join('tmp')}/temp.xls"
    sheet1 = book.worksheet 0
    sheet1.each 1 do |row|
      first_name = row[0]
      last_name = row[1]
      email = row[2]
      enterprise = row[3]
      job = row[4]
      linkedin_url = row[5]
      category = row[6]
      u = JobOffer.new(first_name: first_name, last_name: last_name, email: email,
         enterprise: enterprise, job: job, linkedin_url: linkedin_url,
          category: category, coaching_id: coaching_id, status: 1)
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
      format.html { redirect_to contacts_admin_path(coaching_id: coaching_id,notice: notice)}
    end
  end

  # POST /contacts
  # POST /contacts.json
  def create
    @coaching = Coaching.find(params[:contact][:coaching_id])
    @contact = @coaching.contacts.new(contact_params)
    respond_to do |format|
      if @contact.save
        format.html { redirect_to contacts_admin_path(:coaching_id => @coaching.id), notice: 'Contact was successfully created.' }
        format.json { render :show, status: :created, location: @contact }
      else
        format.html { render :new }
        format.json { render json: @contact.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /contacts/1
  # PATCH/PUT /contacts/1.json
  def update
    respond_to do |format|
      if @contact.update(contact_params)
        format.html { redirect_to @contact, notice: 'Contact was successfully updated.' }
        format.json { render :show, status: :ok, location: @contact }
      else
        format.html { render :edit }
        format.json { render json: @contact.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /contacts/1
  # DELETE /contacts/1.json
  def destroy
    @contact.destroy
    respond_to do |format|
      format.html { redirect_to contacts_url, notice: 'Contact was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_contact
      @contact = Contact.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def contact_params
      params.require(:contact).permit(:first_name, :last_name, :email, :enterprise, :job, :linkedin_url, :consultant, :category, :status)
    end
end
