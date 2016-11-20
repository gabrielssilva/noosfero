class Federation::Diaspora
  def self.webfinger_lookup(query)
    # TODO: add test after integrate the webmock gem
    begin
      DiasporaFederation::Discovery::Discovery.new(query).fetch_and_save
    rescue DiasporaFederation::Discovery::DiscoveryError => e
      Rails.logger.debug "Unable to fetch webfinger for #{query}: #{e}"
    end
  end
end
