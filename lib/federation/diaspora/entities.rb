module Federation::Diaspora::Entities
  def self.contact(author, person)
    DiasporaFederation::Entities::Contact.new(
      # TODO: use correct source handle
      author: "#{author.identifier}@noosfero.local",
      recipient: person.diaspora_handle,
      sharing: true
    )
  end
end
