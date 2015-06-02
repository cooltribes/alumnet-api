class AddMailchimpFieldsToGroups < ActiveRecord::Migration
  def change
  	add_column :groups, :mailchimp, :bool, default: false
    add_column :groups, :api_key, :string
    add_column :groups, :list_id, :string
  end
end
