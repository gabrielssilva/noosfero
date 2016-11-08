class OpenidClientPluginController < ApplicationController
  # TODO: extract redirect url to conf file

  def discover
    provider = OpenidClientPlugin::Provider.discover(params[:provider][:host])
    redirect_url = url_for({ action: :authenticate, provider_id: provider.id })
    provider.register(redirect_url) unless provider.registered?

    session[:nonce] = SecureRandom.hex(16)
    redirect_to provider.authorization_uri(redirect_url, session[:nonce])
  end

  def authenticate
    provider = OpenidClientPlugin::Provider.find(params[:provider_id])
    nonce = session.delete(:nonce)
    redirect_url = url_for({ action: :authenticate, provider_id: provider.id })

    provider.authenticate(redirect_url, params[:code], nonce)
    render text: "authenticated"
  end
end
