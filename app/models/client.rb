class Client
  include Mongoid::Document
  
  field :name,          type: String
  field :email,         type: String
  field :phone_number,  type: String
  field :other_data,    type: Hash,    default: {}
  
  validates_presence_of :name, :email, :phone_number
  validates_uniqueness_of :email
  
  has_one :account
  
  class << self
    def add_new(inputs, data = {})
      client = Client.new(inputs)
      client.account = Account.new
      client.save!
      client
    end
  end
end