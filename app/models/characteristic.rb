class Characteristic < ActiveRecord::Base
	enum status: [:inactive, :active]
	
	validates_presence_of :name
end
