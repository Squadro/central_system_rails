class Palette
  include Mongoid::Document
  
  field :code,                  :type => String   #P001, P002 etc
  field :other_data,            :type => Hash,    :default => {}
  
  validates_presence_of :code
  validates_uniqueness_of :code
  
  has_and_belongs_to_many :colors  # A palette can have many colors.
                                   # And a color can be a part of many palettes. A N:N association
  has_many :products
       
  #TODO: Write validation for code to start with P and not exceed 4 characters
  class << self
    def add_new(inputs, data = {})
      new_palette = Palette.new(inputs.except(:colors))
      if inputs[:colors] && inputs[:colors].kind_of?(Array)
        colors = Color.find(inputs[:colors]).to_a
        p colors  # This correctly prints the colors that was  chosen in the form.
        
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
