require 'typhoeus'

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
      identifier, domain = person.profile.author.split('@')
      name = "#{person.profile.first_name} #{person.profile.last_name}"

      ExternalPerson.get_or_create(OpenStruct.new(
        identifier: identifier,
        name: name.blank? ? identifier : name,
        domain: domain,
        email: "#{identifier}@#{domain}",
        created_at: Time.now
      ), {
        guid: person.guid,
        public_key: person.exported_key
        # TODO: adds profile image url
      })
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
