class User
  include Mongoid::Document
  include Mongoid::Timestamps
  
  # Include default devise modules. Others available are:
  # :registerable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable,
         :recoverable, :rememberable, :trackable, :validatable, authentication_keys: [:login]
  
  ## Database authenticatable
  field :phone_number,       :type => String
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
  
  field :type,          type: String
  field :other_data,    type: Hash,    default: {}
  
  ALLOWED_USER_TYPES = ["Designer", "Project Manager", "Admin", "Manager"]
  
  validates_presence_of :phone_number, message: 'Please send your phone number'
  validates_presence_of :name, :email
  validates_uniqueness_of :phone_number, message: 'User with that phone number already exists'
  validates_inclusion_of :type, in: ALLOWED_USER_TYPES
  

  def login=(login)
    @login = login
  end

  def login
    @login || self.phone_number || self.email
  end

  def self.find_for_database_authentication(warden_conditions)
    conditions = warden_conditions.dup
    if login = conditions.delete(:login).downcase
      where(conditions).where('$or' => [ {:phone_number => /^#{Regexp.escape(login)}$/i}, {:email => /^#{Regexp.escape(login)}$/i} ]).first
    else
      where(conditions).first
    end
  end

  def email_required?
    super && phone_number.blank?
  end
  
  class << self
    def add_new(inputs, current_user, data = {})
      
      #Check if user is logged in
      if current_user
        #user is logged in. Now check if its the request from same user
        if current_user.phone_number == inputs[:phone_number] 
          #Request is from a registered user who is currently logged in.
          #Add the new address if the address is already not present.
          current_user.save!
          return current_user
        else
          #Request is from a different user so raise error
          raise Exception, 'Request is from unauthorized user'
        end
      else
        #User is not logged in. Now check if user exists
        existing_users = User.customer_of(inputs[:merchant_id]).with_phone_number(inputs[:phone_number])
        if existing_users.length == 0
          #User does not exist. Create one.
          merchant = Merchant.find(inputs[:merchant_id])
          user = User.new(inputs.slice(:name, :phone_number, :email, :profile_pic))
          if inputs[:password] && inputs[:password] != ""
            user.password = inputs[:password]
          else
            raw, enc = Devise.token_generator.generate(User, :reset_password_token)
            user.password = raw
          end
          user.add_address(inputs[:address])
          user.merchant = merchant          
          user.save!
          return user
        else
          #User exists with this phone number but not logged in.
          #Lets login for now. We can think of validating by asking to enter password to continue.
          user = existing_users[0]
          user.add_address(inputs[:address])
          user.save!
          return user
        end
      end
      
    end
  end
end