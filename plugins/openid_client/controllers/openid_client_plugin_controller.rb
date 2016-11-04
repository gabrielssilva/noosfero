class OpenidClientPluginController < ApplicationController

  def discover
    provider = OpenidClientPlugin::Provider.discover(params[:provider][:host])
    render text: "provider successfully discovered"
  end

end
