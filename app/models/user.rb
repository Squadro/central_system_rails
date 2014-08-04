class User
  include Mongoid::Document
  include Mongoid::Timestamps
  
  # Include default devise modules. Others available are:
  # :registerable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable,
         :recoverable, :rememberable, :trackable, :validatable #, :registerable, authentication_keys: [:login]
  
  ## Database authenticatable
  field :role,               :type => String
  field :full_name,          :type => String
  field :email,              :type => String, :default => ""
  field :encrypted_password, :type => String, :default => ""
  
  ## Recoverable
  field :reset_password_token,   :type => String
  field :reset_password_sent_at, :type => Time

  ## Rememberable
  field :remember_created_at, :type => Time

  ## Trackable
  field :sign_in_count,      :type => Integer, :default => 0
  field :current_sign_in_at, :type => Time
  field :last_sign_in_at,    :type => Time
  field :current_sign_in_ip, :type => String
  field :last_sign_in_ip,    :type => String
  
  field :name,              type: String
  field :profile_pic,       type: String
  
  field :other_data,    type: Hash,    default: {}
  
  ROLES = %w[designer admin content_writer super_admin]
  
  validates_presence_of :name, :email
  
  #scope :with_email, ->(email) { where(:email => email) }
  
  
  class << self
    def add_new(inputs, data = {})
      user = self.new(inputs)
      user.save!
      user      
    end
  end
end