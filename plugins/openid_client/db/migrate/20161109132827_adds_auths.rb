class AddsAuths < ActiveRecord::Migration
  def up
    create_table :openid_client_plugin_auths do |t|
      t.integer :provider_id
      t.integer :external_person_id

      t.string :profile_url
      t.string :picture_url
      t.timestamps
    end
  end

  def down
    drop_table :openid_client_plugin_auths
  end
end
