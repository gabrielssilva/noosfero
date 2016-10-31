DiasporaFederation.configure do |config|
  config.server_uri = URI('http://localhost:3000')

  config.define_callbacks do
    on :fetch_person_for_webfinger do |diaspora_id|
      # ...
    end

    on :fetch_person_for_hcard do |guid|
      # ...
    end

    on :save_person_after_webfinger do |person|
      # ...
    end

    on :fetch_private_key do |diaspora_id|
      # ...
    end

    on :fetch_public_key do |diaspora_id|
      # ...
    end

    on :fetch_related_entity do |entity_type, guid|
      # ...
    end

    on :queue_public_receive do |xml, legacy=false|
      # ...
    end

    on :queue_private_receive do |guid, xml, legacy=false|
      # ...
    end

    on :receive_entity do |entity, _sender, recipient_id|
      # ...
    end

    on :fetch_public_entity do |entity_type, guid|
      # ...
    end

    on :fetch_person_url_to do |diaspora_id, path|
      # ...
    end

    on :update_pod do |url, status|
      # ...
    end
  end
end
