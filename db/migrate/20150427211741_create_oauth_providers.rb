class CreateOauthProviders < ActiveRecord::Migration
  def change
    create_table :oauth_providers do |t|
      t.string :provider
      t.string :uid
      t.string :oauth_token
      t.references :user, index: true

      t.timestamps
    end
  end
end
