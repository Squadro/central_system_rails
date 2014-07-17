class ProductCode
  include Mongoid::Document
  
  field :name,                  :type => String   #BC, CC etc
  field :description,           :type => String   #Book case is BC
  field :other_data,            :type => Hash,    :default => {}
  
  validates_presence_of :name, message: 'fill product code'
  validates_uniqueness_of :name, message: 'already taken. Choose another'
  validates_length_of :name, is: 2, message: 'should be two characters in length'
  validates_format_of :name, with: /\A[A-Z][A-Z]\Z/, message: 'should have uppercase characters'
  
  validates_presence_of :description, message: 'Fill the description'
  
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
