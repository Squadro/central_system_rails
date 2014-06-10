class Upload
  include Mongoid::Document
  include Mongoid::Timestamps

  field :type, :type => String
  field :url, :type => String
end