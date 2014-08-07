class Color
  include Mongoid::Document
  
  field :code,                  :type => String   # SL001, SL002 etc
  field :laminate_brand,        :type => String
  field :catalogue_type,        :type => String
  field :catalogue_page_no,     :type => Integer
  field :vendor_product_code,   :type => String
  field :grain_type,            :type => String
  field :finish_type,           :type => String
  field :meta,                  :type => String   # Indicates to which this color is applicable - Laminate, General Color etc
  field :image_url,             :type => String
  field :other_data,            :type => Hash,    :default => {}

  validates_presence_of :code, :image_url, :laminate_brand, :catalogue_type, :catalogue_page_no, :vendor_product_code
  validates_uniqueness_of :code, message: "is already taken. Please choose another code"
  validates_format_of :code, with: /\A[S][L]\d\d\d\Z/, message: 'should be in format SLXXX, where X is a digit. Example SL004'
  
  has_and_belongs_to_many :palettes   # A color can be a part of many palettes
                                      # And a palette can have many colors. A N:N association 
  has_many :products
  
  FINISH_TYPES = ["MATTE", "GLOSSY", "BUMPY"]
  GRAIN_TYPES  = ["NONE", "HORIZONTAL", "VERTICAL"]
  LAMINATE_BRAND_TYPES = ["Associate", "Airolam", "Bloom"]
  CATALOGUE_TYPES = ["1mm Associate Woods 2014", "1mm Assoicate Solids 2014", "0.8mm Associate 2014", "1mm Airolam Decor Laminates 2014", "0.8mm Airolite", "1mm Airolam Pearl 2014", "1mm Bloom 2014"]

  # TODO: validation - laminate_brand, catalogue_type, grain_type. finish_type - need to be part of the constants    

  class << self
    def add_new(inputs, data = {})
      color = Color.new(inputs)
      color.save!
      color
    end
  end
end
