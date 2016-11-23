require 'typhoeus'

DiasporaFederation.configure do |config|
  # TODO: get from domain
  config.server_uri = URI('http://noosfero.local')

  config.define_callbacks do
    on :fetch_person_for_webfinger do |diaspora_id|
      identifier = diaspora_id.split('@').first
      person = Person.find_by(identifier: identifier)

      if person
        pod_url = config.server_uri.to_s

        DiasporaFederation::Discovery::WebFinger.new(
          acct_uri: "acct:#{diaspora_id}",
          alias_url: "#{pod_url}/profile/#{identifier}",
          hcard_url: "#{pod_url}/hcard/users/#{person.guid}",
          seed_url: pod_url,
          profile_url: "#{pod_url}/profile/#{identifier}",
          salmon_url: "#{pod_url}/receive/users/#{person.guid}",
          subscribe_url: "#{pod_url}/search/people?query={uri}",
          atom_url: nil,
          guid: person.guid,
          public_key: person.public_key.to_s
        )
      end
    end

    on :fetch_person_for_hcard do |guid|
      person = Person.find_by(guid: guid)

      if person
        pod_url = config.server_uri.to_s
        names = person.name.split

        DiasporaFederation::Discovery::HCard.new(
          guid: person.guid,
          nickname: person.identifier,
          full_name: person.name,
          url: pod_url,
          photo_large_url: "#{pod_url}/profile/#{person.identifier}/icon/big",
          photo_medium_url: "#{pod_url}/profile/#{person.identifier}/icon/portrait",
          photo_small_url: "#{pod_url}/profile/#{person.identifier}/icon/icon",
          public_key: person.public_key.to_s,
          searchable: true,
          first_name: names.first,
          last_name: (names.last if names.size > 1)
        )
      end
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
