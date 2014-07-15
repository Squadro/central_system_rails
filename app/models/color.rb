class Color
  include Mongoid::Document
  
  field :code,                  :type => String   # SL001, SL002 etc
  field :laminate_brand,        :type => String
  field :catalogue_type,        :type => String
  field :catalogue_page_no,     :type => String
  field :vendor_product_code,   :type => String
  field :grain_type,            :type => String
  field :finish_type,           :type => String
  field :meta,                  :type => String   # Indicates to which this color is applicable - Laminate, General Color etc
  field :image_url,             :type => String
  field :other_data,            :type => Hash,    :default => {}

  validates_presence_of :code, :image_url
  validates_uniqueness_of :code
  
  has_and_belongs_to_many :palettes   # A color can be a part of many palettes
                                      # And a palette can have many colors. A N:N association 
  has_many :products
  
  FINISH_TYPES = ["MATTE", "GLOSSY", "BUMPY"]
  GRAIN_TYPES  = ["NONE", "HORIZONTAL", "VERTICAL"]
  
  #TODO: Write validation for code to start with SL and not exceed 5 characters
  class << self
    def add_new(inputs, data = {})
      color = Color.new(inputs)
      color.save!
      color
    end
  end
end
