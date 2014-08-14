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
  field :height,                type: Float
  field :depth,                 type: Float
  field :weight,                type: Float
  field :material_type,         type: String # PLY, MDF, PTB TODO: Add the ALLOWED_MATERIAL_TYPES
  field :mounting_type,         type: String # Wallmount, Freestanding TODO: Add the ALLOWED_MOUNTING TYPES
  field :finish_type,           type: String # Laminate, Vinear, Acrylic TODO: Add the ALLOWED_FINISH_TYPES
  
  # Maintenence
  field :usage_terms,           type: String
  field :cleaning_of_product,   type: String
  field :sl_or_palette,         type: String  # SL if SL, PALETTE if Palette 
  
  # Warranty
  field :warranty_terms,          type: String
  field :warranty_period,         type: String
  
  # Renders
  field :left_angle_render_url,      type: String
  field :right_angle_render_url,     type: String
  field :front_render_url,           type: String
  field :decorated_front_render_url, type: String
  
  # Images
  field :inside_view_one,            type: String
  field :inside_view_two,            type: String
  field :dimensions_image_one,       type: String
  field :dimensions_image_two,       type: String
  field :sketchup_file_embed_code,   type: String
  
  field :other_data,            type: Hash,    :default => {}
  
  MATERIAL_TYPES = ["PLY", "MDF", "PTB", "PLY+MDF", "PLY+PTB"]
  MOUNTING_TYPES = ["WALL MOUNTING", "FREE STANDING", "COMBO MOUNT"]
  FINISH_TYPES = ["LAMINATE", "VINEAR", "ACRYLIC"]
  
  belongs_to :product_code  # You can assume product_code to be Product_category.
                            # Hence very logical to say - Product belongs to a Product_category 
  belongs_to :color
  belongs_to :palette
  
  before_create :set_everything
  before_update :set_everything
  
  # TODO: Validate all the Allowed stuff
  # TODO: Validate the palette_sl_code to be a palette code or a sl code.
  
  validates_presence_of :product_code_id, :title, :model_number, :variation_number, message: "should be present"
  validates_uniqueness_of :model_code, message: "should be unique"
  validates_numericality_of :warranty_period, :length, :height, :depth, :weight, :pricing, :model_number, :variation_number, message: "should be a number"
  
  def update_product_attributes(safe_params)
    self.update_attributes(safe_params.except(:product_code_id, :sl_or_palette_radio))
    self.product_code = ProductCode.find(safe_params[:product_code_id])
    self.palette = Palette.find(safe_params[:palette_id]) if safe_params[:palette_id].present?
    self.color = Color.find(safe_params[:color_id]) if safe_params[:color_id].present?
    
    if safe_params[:sl_or_palette_radio].present?
      if safe_params[:sl_or_palette_radio] == 'SL'
        self.sl_or_palette = 'SL'
      else
        self.sl_or_palette = 'Palette'
      end
    end      
    self.save!
  end
  
  class << self
    def add_new(inputs, data = {})
      product = Product.new(inputs.except(:product_code_id, :sl_or_palette_radio))
      product.product_code = ProductCode.find(inputs[:product_code_id])
      product.palette = Palette.find(inputs[:palette_id]) if inputs[:palette_id].present?
      product.color = Color.find(inputs[:color_id]) if inputs[:color_id].present?
      if inputs[:sl_or_palette_radio] == 'SL'
        product.sl_or_palette = 'SL'
      else
        product.sl_or_palette = 'Palette'
      end      
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
    if self.sl_or_palette == 'Palette'
      self.palette_or_color = self.palette.code
    else
      self.palette_or_color = self.color.code
    end
  end
  
  def set_model_code
    code = ProductCode.find(self.product_code).name
    self.model_code = code + self.model_number.to_s + "." + self.variation_number.to_s + "_" + self.palette_or_color
  end
  
end
