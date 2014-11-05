class Profile < ActiveRecord::Base

    #Relations
    belongs_to :user

    #Validations
    validates_presence_of :first_name, :last_name, on: :update
end
