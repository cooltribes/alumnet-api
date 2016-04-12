class Category < ActiveRecord::Base
	enum status: [:inactive, :active]

	has_many :children, class_name: "Category", foreign_key: :father_id
	belongs_to :father, class_name: "Category"
	
	validates_presence_of :name, :description
end