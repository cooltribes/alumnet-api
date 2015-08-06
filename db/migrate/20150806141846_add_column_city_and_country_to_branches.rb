class AddColumnCityAndCountryToBranches < ActiveRecord::Migration
  def change
    add_reference :branches, :country, index: true
    add_reference :branches, :city, index: true
  end
end
