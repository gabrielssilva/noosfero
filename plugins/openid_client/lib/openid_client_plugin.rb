class OpenidClientPlugin < Noosfero::Plugin

  def self.plugin_name
    "OpenID Client Plugin"
  end

  def self.plugin_description
    _("Turns Noosfero into an OpenID Relaying Party.")
  end

  def login_extra_contents
    proc do
      render partial: "auth/openid_login_extra_content"
    end
  end
end
