class OpenidClientPlugin::Auth < ApplicationRecord
  self.table_name = :openid_client_plugin_auths

  attr_accessible :external_person, :provider, :profile_url, :picture_url

  belongs_to :external_person
  belongs_to :provider, class_name: 'OpenidClientPlugin::Provider'
end
