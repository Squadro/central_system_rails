class Palette
  include Mongoid::Document
  
  field :code,                  :type => String   #P001, P002 etc
  field :other_data,            :type => Hash,    :default => {}
  
  validates_presence_of :code
  validates_uniqueness_of :code
  validates_length_of :code, is: 4, message: 'should be 4 characters in length'
  validates_format_of :code, with: /\A[P]\d\d\d\Z/, message: 'should be in format PXXX, where X is a digit. Example P002'
  validates_presence_of :colors, message: 'cannot be blank. Add atleast two colors'
    
  has_and_belongs_to_many :colors  # A palette can have many colors.
                                   # And a color can be a part of many palettes. A N:N association
  has_many :products
  
  class << self
    def add_new(inputs, data = {})
      new_palette = Palette.new(inputs.except(:colors))
      if inputs[:colors] && inputs[:colors].kind_of?(Array)
        colors = Color.find(inputs[:colors]).to_a        
        colors.each do |color|
          new_palette.colors << color
          color.save!
        end
      end
      new_palette.save!
      new_palette
    end
  end
  
end
