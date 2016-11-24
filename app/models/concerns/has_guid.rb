module HasGUID
  extend ActiveSupport::Concern

  included do
    attr_accessible :guid
  end

  def guid
    generate_guid unless self[:guid].present?
    self[:guid]
  end

  private

  def generate_guid
    update_attributes(guid: SecureRandom.uuid)
  end
end
