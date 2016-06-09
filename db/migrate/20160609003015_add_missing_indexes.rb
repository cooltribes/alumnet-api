class AddMissingIndexes < ActiveRecord::Migration
  def change
    add_index :albums, [:albumable_id, :albumable_type]
    add_index :users, [:admin_location_id, :admin_location_type]
    add_index :privacies, :user_id
    add_index :privacies, :privacy_action_id
    add_index :user_taggings, [:taggable_id, :taggable_type]
    add_index :posts, [:postable_id, :postable_type]
    add_index :posts, :postable_id
    add_index :pictures, [:pictureable_id, :pictureable_type]
    add_index :pictures, :uploader_id
    add_index :payments, [:paymentable_id, :paymentable_type]
    add_index :memberships, :group_id
    add_index :memberships, :user_id
    add_index :memberships, [:group_id, :user_id]
    add_index :likes, [:likeable_id, :likeable_type]
    add_index :folders, [:folderable_id, :folderable_type]
    add_index :folders, :creator_id
    add_index :profiles, :birth_city_id
    add_index :profiles, :residence_city_id
    add_index :profiles, :birth_country_id
    add_index :profiles, :residence_country_id
    add_index :profiles, :user_id
    add_index :tasks, :user_id
    add_index :events, :country_id
    add_index :events, :city_id
    add_index :events, :creator_id
    add_index :events, [:eventable_id, :eventable_type]
    add_index :groups, :creator_id
    add_index :companies, :country_id
    add_index :companies, :city_id
    add_index :companies, :sector_id
    add_index :companies, :creator_id
  end
end
