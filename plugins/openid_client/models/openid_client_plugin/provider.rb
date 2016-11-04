class OpenidClientPlugin::Provider < ApplicationRecord
  self.table_name = :openid_client_plugin_providers

  def self.discover(host)
    issuer = OpenIDConnect::Discovery::Provider.discover!(host).issuer
    OpenidClientPlugin::Provider.find_or_create_by(issuer: issuer, name: host)
  end

end
