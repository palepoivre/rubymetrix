class Event
  include Mongoid::Document
  field :type, type: String
  field :nombre, type: Integer
end
