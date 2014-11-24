class Experience < ActiveRecord::Base
  belongs_to :city
  belongs_to :country

  enum type: [:aiesec, :alumni, :academic, :profesional]

end
