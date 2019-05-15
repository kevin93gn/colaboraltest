class CommunicationController < ApplicationController

  before_filter :admin_only, :except => [:index, :coaching, :send_coaching_mail, :users, :send_user_mail]

  def index
  end

  def send_mail(users)
    max_recipents = 900
    if users.count > 0
      recipients = users.each_slice(max_recipents)
      recipients.each do |u|
        @users = u
        CommunicationMailer.communication_mail(@message, @users, current_user).deliver
      end
      true
    else
      false
    end
  end

  def all_users
    @users = User.all
    @communication = CommunicationMail.new
  end

  def send_all_user_mail
    params.permit!
    @message = CommunicationMail.new(params[:communication_mail])
    @message.user_id = current_user.id
    users = User.all
    if send_mail(users)
      redirect_to communication_confirmation_path
    else
      redirect_to root_path
    end
  end

  def teachers
    @users = User.where(:role => 'profesor')
    @communication = CommunicationMail.new
  end

  def send_teacher_mail
    params.permit!
    @message = CommunicationMail.new(params[:communication_mail])
    @message.user_id = current_user.id
    users = User.where(:role => 'profesor')
    if send_mail(users)
      redirect_to communication_confirmation_path
    else
      redirect_to root_path
    end
  end

  def users
    @communication = CommunicationMail.new
    @user = User.find(params[:user_id])
    if @user.nil?
      redirect_to root
    end
  end

  def send_user_mail
    params.permit!
    @message = CommunicationMail.new(params[:communication_mail])
    @message.user_id = current_user.id
    @users = User.where(:id => params[:user_id])
    if @users.count > 0
      CommunicationMailer.communication_mail(@message, @users, current_user).deliver
      redirect_to communication_confirmation_path
    else
      redirect_to root
    end
  end

  def courses
    @communication = CommunicationMail.new
    @course = Course.find(params[:course_id])
    @course_id = params[:course_id]
    @users = User.joins('RIGHT JOIN subscriptions ON subscriptions.user_id = users.id')
                 .where(:subscriptions => {:course_id => @course_id}).order('last_name asc')
    if @course.nil?
      redirect_to root
    end
  end

  def send_course_mail
    params.permit!
    @message = CommunicationMail.new(params[:communication_mail])
    @message.user_id = current_user.id
    @course_id = params[:course_id]
    users = User.joins('RIGHT JOIN subscriptions ON subscriptions.user_id = users.id')
                 .where(:subscriptions => {:course_id => @course_id}).order('last_name asc')
    if send_mail(users)
      redirect_to communication_confirmation_path
    else
      redirect_to root_path
    end
  end

  def coaching
    @communication = CommunicationMail.new
    @coaching = Coaching.find(params[:coaching_id])
    @users = User.joins('RIGHT JOIN coachees ON coachees.user_id = users.id')
                 .where(:coachees => {:coaching_id => @coaching.id})
    if @coaching.nil?
      redirect_to root
    end
  end

  def send_coaching_mail
    params.permit!
    @message = CommunicationMail.new(params[:communication_mail])
    @message.user_id = current_user.id
    @coaching_id = Coaching.find(params[:coaching_id]).id
    users = User.joins('RIGHT JOIN coachees ON coachees.user_id = users.id')
                 .where(:coachees => {:coaching_id => @coaching_id})
    if send_mail(users)
      redirect_to communication_confirmation_path
    else
      redirect_to root_path
    end
  end

end

