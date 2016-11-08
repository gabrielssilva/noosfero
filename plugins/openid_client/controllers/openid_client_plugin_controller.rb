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
    if params[:code].nil?
      session[:notice] = _('Impossible to authenticate: the authorization server denied the request.')
      return redirect_to(root_path)
    end

    provider = OpenidClientPlugin::Provider.find(params[:provider_id])
    nonce = session.delete(:nonce)
    redirect_url = url_for({ action: :authenticate, provider_id: provider.id })

    # TODO: return all info from the provider
    userinfo = provider.authenticate(redirect_url, params[:code], nonce)
    nickname = userinfo.nickname.to_slug
    email = userinfo.email || "#{nickname}@#{provider.name}"

    person = ExternalPerson.get_or_create(OpenStruct.new(
      identifier: nickname,
      name: userinfo.name,
      domain: provider.name,
      email: email,
      created_at: Time.now
    ))

    user = User.new(login: nickname, email: email)
    user.external_person_id = person.id
    self.current_user = user

    redirect_to root_path
  end
end
