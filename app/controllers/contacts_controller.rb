class ContactsController < ApplicationController
  before_action :set_contact, only: [:show, :edit, :update, :destroy]

  # GET /contacts
  # GET /contacts.json
  def index
    @contacts = Contact.all
  end
  
  def my_contacts
    @contacts = Contact.where(user_id: params[:user_id])
  end

  def admin
    user_id = params[:user_id]
    @coachee = User.find(params[:coachee_id])
  end

  def change_status
    @contact = Contact.find(params[:id])
    respond_to do |format|
      if @contact.update(status: params[:status])
        if params[:coachee_id].present?
        format.html { redirect_to contacts_admin_path(:coachee_id => params[:coachee_id]), notice: "Estatus del contacto #{@contact.email} actualizado exitosamente" }
      else
        format.html { redirect_to my_contacts_path(:user_id => current_user.id), notice: "Estatus del contacto #{@contact.email} actualizado exitosamente" }
      end
        format.json { render :show, status: :ok, location: @contact }
      else
        format.html { redirect_to contacts_admin_path(:coachee_id => params[:coachee_id]), notice: "Falló al cambiar el estatus del contacto #{@contact.email}" }
        format.json { render json: @contact.errors, status: :unprocessable_entity }
      end
    end
  end
  
  def reject_contact
    @contact = Contact.find(params[:id])
  end
  
  def rejected_contact
    @contact = Contact.find(params[:id])
    respond_to do |format|
      if @contact.update(status: 4, reject_reason: params[:contact][:reject_reason])
        if params[:coachee_id].present?
        format.html { redirect_to contacts_admin_path(:coachee_id => params[:coachee_id]), notice: "Estatus del contacto #{@contact.email} actualizado exitosamente" }
        else
          format.html { redirect_to my_contacts_path(:user_id => current_user.id), notice: "Estatus del contacto #{@contact.email} actualizado exitosamente" }
        end
        format.json { render :show, status: :ok, location: @contact }
      else
        format.html { redirect_to contacts_admin_path(:coachee_id => params[:coachee_id]), notice: "Falló al cambiar el estatus del contacto #{@contact.email}" }
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
    @coachee = User.find(params[:coachee_id])
  end

  # GET /contacts/1/edit
  def edit
    @coachee = Coachee.find(params[:coachee_id])
  end


  def import
    @coachee = User.find(params[:coachee_id])
  end

  def create_import
    get_file =  params[:excelfile]
    coachee_id = params[:coachee_id]
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
      u = Contact.new(first_name: first_name, last_name: last_name, email: email,
         enterprise: enterprise, job: job, linkedin_url: linkedin_url,
          category: category, user_id: coachee_id, status: 1)
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
      notice = 'Carga completada exitosamente'
    else
      notice = errors
    end
    respond_to do |format|
      format.html { redirect_to contacts_admin_path(coachee_id: coachee_id,notice: notice)}
    end
  end

  # POST /contacts
  # POST /contacts.json
  def create
    @coachee = User.find(params[:contact][:coachee_id])
    @contact = @coachee.contacts.new(contact_params)
    respond_to do |format|
      if @contact.save
        unless current_user.role == "usuario"
          format.html { redirect_to contacts_admin_path(:coachee_id => @coachee.id), notice: 'Contacto creado exitosamente.' }
        else
          format.html { redirect_to my_contacts_path(:user_id => current_user.id), notice: 'Contacto creado exitosamente.' }
        end
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
