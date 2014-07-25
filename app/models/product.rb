class Product
  include Mongoid::Document
  
  field :title,                 type: String
  field :model_number,          type: Integer
  field :variation_number,      type: Integer # TODO: Should auto update starting from 1
  field :palette_or_color,      type: String  # Place where the product's palette/color
  field :model_code,            type: String
  
  field :pricing,               type: Integer
  field :short_description,     type: String
  field :long_description,      type: String   # Book case is BC
    
  # Specifications
  field :length,                type: Float
  field :breadth,               type: Float
  field :height,                type: Float
  field :depth,                 type: Float
  field :weight,                type: Float
  field :material_type,         type: String # PLY, MDF, PTB TODO: Add the ALLOWED_MATERIAL_TYPES
  field :mounting_type,         type: String # Wallmount, Freestanding TODO: Add the ALLOWED_MOUNTING TYPES
  field :finish_type,           type: String # Laminate, Vinear, Acrylic TODO: Add the ALLOWED_FINISH_TYPES
  
  # Maintenence
  field :usage_terms,           type: String
  field :cleaning_of_product,   type: String
  
  # Warranty
  field :warranty_terms,          type: String
  field :warranty_period,         type: String
  
  # Renders
  field :left_angle_render_url,      type: String
  field :right_angle_render_url,     type: String
  field :front_render_url,           type: String
  field :decorated_front_render_url, type: String
  
  field :other_data,            type: Hash,    :default => {}
  
  MATERIAL_TYPES = ["PLY", "MDF", "PTB"]
  MOUNTING_TYPES = ["WALL MOUNTING", "FREE STANDING"]
  FINISH_TYPES = ["LAMINATE", "VINEAR", "ACRYLIC"]
  
  belongs_to :product_code  # You can assume product_code to be Product_category.
                            # Hence very logical to say - Product belongs to a Product_category 
  belongs_to :color
  belongs_to :palette
  
  
  before_create :set_everything
  before_update :set_everything
  
  # TODO: Validate all the Allowed stuff
  # TODO: Validate the palette_sl_code to be a palette code or a sl code.
  
  validates_presence_of :product_code, :title, :model_number, :variation_number, message: "should be present"
  validates_uniqueness_of :model_code, message: "should be unique"
  validates_numericality_of :warranty_period, :length, :breadth, :height, :depth, :weight, :pricing, :model_number, :variation_number, message: "should be a number"
  
  class << self
    def add_new(inputs, data = {})
      product = Product.new(inputs)
      product.save!
      product
    end
  end
  
  protected
  
  def set_everything
    set_palette_or_color 
    set_model_code
  end

  def set_palette_or_color
    if self.palette.present?
      self.palette_or_color = self.palette.code
    elsif self.color.present?
      self.palette_or_color = self.color.code
    end
  end
  
  def set_model_code
    code = ProductCode.find(self.product_code).name
    self.model_code = code + self.model_number.to_s + "." + self.variation_number.to_s + "_" + self.palette_or_color
  end
  
end
