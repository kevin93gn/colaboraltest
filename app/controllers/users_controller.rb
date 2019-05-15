class UsersController < ApplicationController

  before_filter :admin_only

  def index
    @per_page = 50

    rut = params[:rut].to_s
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
    if !rut.nil? and rut != ''
      user = User.where(:rut => rut).first
      if !user.nil?
        redirect_to admin_edit_user_path(:id => user.id)
      else
        @users = User.order('role, id desc').paginate(page: params[:page], per_page: @per_page)
        @message = "Usuario no encontrado"
      end
    end
    @users = User.order('role, id desc').paginate(page: params[:page], per_page: @per_page)
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


  def new
    @user = User.new
    @roles = UserRoles.all
  end

  def create
    params.permit!
    @user = User.new(params[:user])
    @user.password = @user.rut.split('-')[0]
    @user.password_confirmation = @user.password
    if @user.save
      redirect_to user_list_path
    else
      @roles = UserRoles.all
      render :action => 'new'
    end
  end

  def create_external
    params.permit!
    @user = User.new(params[:user])
    if @user.save
      redirect_to user_list_path
    else
      @roles = UserRoles.all
      render :action => 'new'
    end
  end

  def edit
    @user = User.find(params[:id])
    @roles = UserRoles.all

  end

  def update
    @user = User.find(params[:id])
    params.permit!
    if @user.update_attributes(params[:user])
      redirect_to admin_edit_user_path(:id => @user.id)
    else
      render :action => 'edit'
    end
  end

  def import
  end

  def create_import
    get_file =  params[:excelfile]
    File.open("#{Rails.root.join('tmp')}/temp.xls",  'wb') do |file|
      file.write(get_file.read)
    end
    errors = Array.new
    i = 1
    book = Spreadsheet.open "#{Rails.root.join('tmp')}/temp.xls"
    sheet1 = book.worksheet 0
    sheet1.each 1 do |row|
      rut = row[0]
      name = row[1]
      last_name = row[2]
      if !row[0].nil?
        temp_password = row[0].split('-')[0]
      end
      email = row[3]
      cliente = row[4]
      role = row[5]
      profession = row[6]
      branch = row[7]
      u = User.new(:first_name => name, :last_name => last_name, :email => email, :password => temp_password, :password_confirmation => temp_password, :rut => rut.upcase, :role => role, :institution => cliente, :profession => profession, :branch => branch)
      if !u.save
         errors.push("Error de formato en la linea #{i}")
         puts "Error en linea: #{i} mail: #{email}"
      end
      i=i+1
      flash[:errors] = errors
    end
    redirect_to root_path
  end

  def delete
    user = User.find(params[:id])
    unless user.nil?
      coachee_goals = CoacheeGoal.where(:user_id => user.id)
      coaching_sessions = CoachingSession.where(:user_id => user.id)
      coaching_activities = CoachingActivity.where(:user_id => user.id)
      communication_mails = CommunicationMail.where(:user_id => user.id)
      module_item_user = ModuleItemsUsers.where(:user_id => user.id)
      graphs = CoachingGraph.where(:user_id => user.id)
      coachees = Coachee.where(:user_id => user.id)
      graph = CoachingGraph.where(:user_id => user.id)
      subcriptions = Subscription.where(:user_id => user.id)
      user_evaluations = UserEvaluation.where(:user_id => user.id)

      coachee_goals.each do |g|
        g.destroy
      end
      coaching_sessions.each do |s|
        s.destroy
      end
      coaching_activities.each do |ca|
        ca.destroy
      end
      communication_mails.each do |ca|
        ca.destroy
      end
      module_item_user.each do |miu|
        miu.destroy
      end
      graphs.each do |g|
        g.destroy
      end
      coachees.each do |c|
        c.destroy
      end
      graph.each do |g|
        g.destroy
      end
      subcriptions.each do |s|
        s.destroy
      end
      user_evaluations.each do |ue|
        answer = QuestionAnswer.where(:user_evaluation_id => ue.id )
        answer.each do |a|
          a.destroy
        end
        ue.destroy
      end
      user.destroy
      redirect_to user_list_path
    end
  end


end
