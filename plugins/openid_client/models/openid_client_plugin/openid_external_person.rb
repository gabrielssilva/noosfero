class OpenidClientPlugin::OpenidExternalPerson < ExternalPerson

  has_one :openid_auth, foreign_key: 'external_person_id', class_name: 'OpenidClientPlugin::Auth'

  def self.get_or_create(user_data)
    external_person = super
    external_person.type = self.name
    external_person.save

    external_person
  end

  def avatar
    self.openid_auth.picture_url
  end

  def public_profile_url
    self.openid_auth.profile_url
  end

  def url
    self.openid_auth.profile_url
  end

  def admin_url
    self.openid_auth.profile_url
  end
end
