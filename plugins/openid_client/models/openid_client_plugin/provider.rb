class OpenidClientPlugin::Provider < ApplicationRecord
  self.table_name = :openid_client_plugin_providers

  validates :issuer, presence: true, uniqueness: true

  def expired?
    expires_at.try(:past?)
  end

  def registered?
    self.identifier.present? && !self.expired?
  end

  def client
    @client ||= OpenIDConnect::Client.new(self.to_h)
  end

  def config
    @config ||= OpenIDConnect::Discovery::Provider::Config.discover!(issuer)
  end

  def to_h
    {
      identifier: self.identifier,
      secret: self.secret,
      token_endpoint: self.token_endpoint,
      authorization_endpoint: self.authorization_endpoint,
      userinfo_endpoint: self.userinfo_endpoint
    }
  end

  def self.discover(host)
    issuer = OpenIDConnect::Discovery::Provider.discover!(host).issuer
    OpenidClientPlugin::Provider.where(issuer: issuer).first_or_create(name: host)
  end

  def register(redirect_uri)
    # TODO: extract client name to config file
    client_reg = OpenIDConnect::Client::Registrar.new(
      config.registration_endpoint,
      client_name: 'Noosfero',
      application_type: 'web',
      redirect_uris: [redirect_uri]
    ).register!
    self.update_attributes(
      identifier: client_reg.identifier,
      secret: client_reg.secret,
      authorization_endpoint: self.config.authorization_endpoint,
      token_endpoint: self.config.token_endpoint,
      userinfo_endpoint: self.config.userinfo_endpoint,
      expires_at: client_reg.expires_in.try(:from_now)
    )
  end

  def authorization_uri(redirect_uri, nonce)
    # TODO: request different scopes for each provider
    client.redirect_uri = redirect_uri
    client.authorization_uri(
      response_type: :code,
      nonce: nonce,
      state: nonce,
      scope: ["name", "nickname", "picture"]
    )
  end

  def auth_method
    auth_methods = config.token_endpoint_auth_methods_supported
    auth_methods.try(:include?, 'client_secret_basic') ? :basic : :post
  end

  def authenticate(redirect_uri, code, nonce)
    client.redirect_uri = redirect_uri
    client.authorization_code = code

    client.access_token!(self.auth_method).userinfo!
  end
end
