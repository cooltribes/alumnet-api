class AddColumnDeletedAtToOauthProviders < ActiveRecord::Migration
  def change
    add_column :oauth_providers, :deleted_at, :datetime
  end
end
