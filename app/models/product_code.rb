class ProductCode
  include Mongoid::Document
  
  field :name,                  :type => String   #BC, CC etc
  field :description,           :type => String   #Book case is BC
  field :other_data,            :type => Hash,    :default => {}
  
  validates_presence_of :name
  validates_uniqueness_of :name
  
  has_many :products            # If this is assumed to be Product_category
                                # Then it is logical has a particular Product_category has many products 
  
  #TODO: Write validation for code to have only two characters
  class << self
    def add_new(inputs, data = {})
      product_code = ProductCode.new(inputs)
      product_code.save!
      product_code
    end
  end
end
