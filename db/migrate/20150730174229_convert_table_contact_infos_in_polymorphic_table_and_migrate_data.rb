class ConvertTableContactInfosInPolymorphicTableAndMigrateData < ActiveRecord::Migration
  def change
    add_column :contact_infos, :contactable_type, :string
    add_column :contact_infos, :contactable_id, :integer
    add_index :contact_infos, [:contactable_id, :contactable_type]

    ## DATA MIGRATION
    ContactInfo.all.each do |contact|
      contact.update(contactable_type: "Profile", contactable_id: contact.profile_id)
    end

    remove_column :contact_infos, :profile_id
  end
end
