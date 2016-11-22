class FollowRemotePersonJob < Struct.new(:user, :remote_person)
  def perform
    # TODO: geenrate urls dynamically?
    target_url = "https://#{remote_person.source}/receive/users/#{remote_person.guid}"
    salmon_xml = DiasporaFederation::Salmon::EncryptedSlap.prepare(
      "#{user.identifier}@noosfero.local",
      user.private_key,
      Federation::Diaspora::Entities.contact(user, remote_person)
    ).generate_xml(remote_person.public_key)

    target_to_retry = DiasporaFederation::Federation::Sender.private(
      user.id,
      "ExternalPerson@#{remote_person.guid}",
      [[target_url, salmon_xml]].to_h
    )

    if target_to_retry.present?
      Delayed::Worker.logger.debug("Could not deliver to #{target_url}. Trying again in 10 minutes.")
      Delayed::Job.enqueue(FollowRemotePersonJob.new(user, remote_person), run_at: 10.minutes.from_now)
    end
  end
end
