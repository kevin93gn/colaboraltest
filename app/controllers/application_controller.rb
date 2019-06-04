class ApplicationController < ActionController::Base

  protect_from_forgery with: :exception
  before_action :authenticate_user!, :except => [:create_external]

  before_filter :configure_permitted_parameters, if: :devise_controller?

  def admin_only
    redirect_to root_path unless current_user && current_user.admin?
  end

  def teacher_only
    redirect_to root_path unless current_user && (current_user.admin? or current_user.teacher? or current_user.coach?)
  end

  def coach_only
    redirect_to root_path unless current_user && (current_user.admin? or current_user.teacher? or current_user.coach?)
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:first_name, :last_name, :email, :password, :password_confirmation, :rut, :role, :current_password, :profession, :institution, :phone, :mobile, :company_name, :company_rut, :company_region, :company_phone, :company_email, :company_address, :company_activity, :company_type, :external_user, :branch])
    devise_parameter_sanitizer.permit(:account_update, keys: [:first_name, :last_name, :email, :password, :password_confirmation, :rut, :role, :current_password, :profession, :institution, :phone, :mobile, :company_name, :company_rut, :company_region, :company_phone, :company_email, :company_address, :company_activity, :company_type, :branch])
  end

end
