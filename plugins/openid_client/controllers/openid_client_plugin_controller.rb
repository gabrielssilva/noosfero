class OpenidClientPluginController < ApplicationController
  # TODO: extract redirect url to conf file

  def index
    redirect_to(root_path) if self.current_user.present?
  end

  def discover
    begin
      provider = OpenidClientPlugin::Provider.discover(params[:provider][:host])
      nonce = SecureRandom.hex(16)
      redirect_url = url_for({ action: :authenticate, provider_id: provider.id })

      provider.register(redirect_url) unless provider.registered?
      redirect_to provider.authorization_uri(redirect_url, nonce)
    rescue SocketError
      session[:notice] = _('Invalid OpenID provider.')
      redirect_to url_for({ action: :index })
    end
  end

  def authenticate
    if params[:code].present?
      provider = OpenidClientPlugin::Provider.find(params[:provider_id])
      redirect_url = url_for({ action: :authenticate, provider_id: provider.id })

      user_data = provider.authenticate(redirect_url, params[:code])
      person = OpenidClientPlugin::OpenidExternalPerson.get_or_create(user_data)
      user = User.new(login: user_data.identifier, email: user_data.email)
      user.external_person_id = person.id
      self.current_user = user

      OpenidClientPlugin::Auth.where(
        provider: provider,
        external_person: person
      ).first_or_create(
        profile_url: user_data.profile,
        picture_url: user_data.picture
      )
    else
      session[:notice] = _('Impossible to authenticate: the authorization server denied the request.')
    end

    redirect_to root_path
  end
end
