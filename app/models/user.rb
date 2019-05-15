class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  mount_uploader :avatar_url, Avatar

  has_many :coachings
  has_many :coachees
  has_many :coaching_graphs
  has_many :coaching_news
  has_many :job_offers

  valid_email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  #valid_rut_regex = /\A^(\d{1,2}\.\d{3}\.\d{3}-)([a-zA-Z]{1}$|\d{1}$)+\z/i

  validates_presence_of :email, :first_name, :last_name

  validates_presence_of :profession, :if => :external_user?
  validates_presence_of :phone, :if => :external_user?
  validates_presence_of :mobile, :if => :external_user?
  validates_presence_of :company_name, :if => :external_user?
  validates_presence_of :company_region, :if => :external_user?
  validates_presence_of :company_phone, :if => :external_user?
  validates_presence_of :company_email, :if => :external_user?
  validates_presence_of :company_address, :if => :external_user?
  validates_presence_of :company_activity, :if => :external_user?
  validates_presence_of :company_type, :if => :external_user?


  validates :email,
            presence: true,
            format: { with: valid_email_regex }

=begin
  validates :rut,
            presence: true,
            uniqueness: true,
            format: { with: valid_rut_regex }


  validates :company_rut,
            presence: true,
            format: { with: valid_rut_regex },
            :if => :external_user?
=end
  validates :company_email, format: { with: valid_email_regex }, :if => :external_user?

  before_save :email_to_lowercase, :set_institution_value
  before_update :email_to_lowercase

  def admin?
    self.role == 'administrador'
  end

  def user?
    self.role == 'usuario'
  end

  def teacher?
    self.role == 'profesor'
  end

  def coach?
    self.role == 'coach'
  end

  def external_user?
    if !self.external_user.nil?
      return external_user
    else
      return false
    end
  end

  def full_name
    "#{first_name} #{last_name}"
  end



  private
  def email_to_lowercase
    self.email = self.email.downcase
  end

  private
  def password_required?
    new_record? ? super : false
  end

  private
  def set_institution_value
    if external_user?
      self.institution = self.company_name
    end
  end
end
