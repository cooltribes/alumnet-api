class Category < ActiveRecord::Base
	enum status: [:inactive, :active]
	
	validates_presence_of :name, :description
end