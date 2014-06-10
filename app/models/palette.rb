class Palette
  include Mongoid::Document
  
  field :code,                  :type => String   #P001, P002 etc
  field :other_data,            :type => Hash,    :default => {}
  
  validates_presence_of :code
  validates_uniqueness_of :code
  
  has_many :colors
  
  #TODO: Write validation for code to start with P and not exceed 4 characters
  class << self
    def add_new(inputs, colors, data = {})
      palette = Palette.new(inputs)
      palette.colors = colors
      palette.save!
      palette
    end
  end
end
