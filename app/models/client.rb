class Client
  include Mongoid::Document
  
  field :name,          type: String
  field :email,         type: String
  field :phone_number,  type: String
  field :other_data,    type: Hash,    default: {}
  
  validates_presence_of :name, :email, :phone_number
  validates_uniqueness_of :email
  
  class << self
    def add_new(inputs, data = {})
      client = Client.new(inputs)
      client.save!
      client
    end
  end
end