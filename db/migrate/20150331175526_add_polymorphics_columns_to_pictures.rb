class AddPolymorphicsColumnsToPictures < ActiveRecord::Migration
  def change
    add_column :pictures, :pictureable_type, :string
    add_column :pictures, :pictureable_id, :integer
  end
end
