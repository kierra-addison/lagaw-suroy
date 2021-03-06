class User < ApplicationRecord
  has_many :tags, dependent: :destroy
  has_many :destinations, through: :tags

  has_secure_password

  extend FriendlyId
  friendly_id :combine_first_last, use: :slugged

  def combine_first_last
    self.first_name + " " + self.last_name
  end
  
  def editor?
    self.role == 'editor'
  end
  
  def admin?
    self.role == 'admin'
  end

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  
  validates :first_name, presence: true,
            length: {minimum: 2, maximum: 20}
  validates :last_name, presence: true,
            length: {minimum: 2, maximum: 20}
  validates :email, presence: true, 
            length: {minimum: 17, maximum: 30}, 
            uniqueness: { message: "already taken" }, 
            format: { with: VALID_EMAIL_REGEX }
  validates :password_confirmation, 
            presence: true, if: -> { !password.nil? }
  validates :password, length: { minimum: 8, allow_nil: false } #, :presence => { :on => :create }
  validates :role, presence: true
  
  before_save :capitalize_fields
  before_save :downcase_fields
  
=begin 
  # you only need presence on create
  :presence => { :on => :create },
  # allow_nil for length (presence will handle it on create)
  :length   => { :minimum => 8, :allow_nil => true },
  # and use confirmation to ensure they always match
  :confirmation => true
=end
  
  
  def capitalize_fields
    self.first_name = first_name.split.each { |n| 
      n.capitalize! 
    }.join(' ')
    self.last_name = last_name.split.each { |n| 
      n.capitalize! 
    }.join(' ')
  end
  
  def downcase_fields
    self.email.downcase!
  end
end
