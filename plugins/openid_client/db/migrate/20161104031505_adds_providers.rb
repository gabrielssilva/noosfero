class AddsProviders < ActiveRecord::Migration
  def up
    create_table :openid_client_plugin_providers do |t|
      t.string :issuer
      t.string :name
      t.string :identifier
      t.string :secret
      t.string :authorization_endpoint
      t.string :token_endpoint
      t.string :userinfo_endpoint
      t.datetime :expires_at
    end
  end

  def down
    drop_table :openid_client_plugin_providers 
  end
end
