module Federation::Diaspora::EntityReceiver
  class AuthorDoNotMatch < RuntimeError; end

  def self.handle(entity)
    entity_type = entity.class.name.demodulize.underscore
    send(entity_type, entity)
  end

  def self.status_message(entity)
    author = ExternalPerson.find_by(identifier: entity.author.split('@').first)
    scrap = Scrap.find_or_create_by(guid: entity.guid) do |scrap|
      scrap.content = entity.text
      scrap.sender = author
      scrap.receiver = author
      scrap.created_at = entity.created_at
    end

    raise AuthorDoNotMatch if scrap.sender != author
  end
end
