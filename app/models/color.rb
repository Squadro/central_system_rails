class Color
  include Mongoid::Document
  
  field :code,                  :type => String   # SL001, SL002 etc
  field :meta,                  :type => String   # Indicates to which this color is applicable - Laminate, General Color etc
  field :image_url,             :type => String
  field :other_data,            :type => Hash,    :default => {}

  validates_presence_of :code, :image_url
  validates_uniqueness_of :code
  
  has_and_belongs_to_many :palettes   # A color can be a part of many palettes
                                      # And a palette can have many colors. A N:N association 
  has_many :products
  
  #TODO: Write validation for code to start with SL and not exceed 5 characters
  class << self
    def add_new(inputs, data = {})
      color = Color.new(inputs)
      color.save!
      color
    end
  end
end
