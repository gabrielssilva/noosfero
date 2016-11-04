class AddsProviders < ActiveRecord::Migration
  def up
    create_table :openid_client_plugin_providers do |t|
      t.string :issuer
      t.string :name
    end
  end

  def down
    drop_table :openid_client_plugin_providers 
  end
end
