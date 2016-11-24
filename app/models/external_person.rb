# A pseudo profile is a person from a remote network
class ExternalPerson < ExternalProfile

  include Human
  include ProfileEntity
  include Follower

  SEARCH_FILTERS = {
    :order => %w[more_recent more_popular more_active],
    :display => %w[compact]
  }

  validates_uniqueness_of :identifier, scope: :source
  validates_presence_of :source, :email, :created_at

  attr_accessible :source, :email, :created_at, :guid, :public_key

  scope :visible, -> { }

  def self.get_or_create(webfinger, additional_data = {})
    user = ExternalPerson.find_by(identifier: webfinger.identifier, source: webfinger.domain)
    if user.nil?
      user = ExternalPerson.create!({
        identifier: webfinger.identifier,
        name: webfinger.name,
        source: webfinger.domain,
        email: webfinger.email,
        created_at: webfinger.created_at
      }.merge(additional_data))
    end
    user
  end

  def create_default_set_of_boxes
    NUMBER_OF_BOXES.times do
      self.boxes << Box.new
    end

    default_set_of_blocks.each_with_index do |blocks,i|
      blocks.each do |block|
        self.boxes[i].blocks << block
      end
    end
  end

  def default_set_of_blocks
    [
      [MainBlock.new],
      [ProfileImageBlock.new(:show_name => true)],
    ]
  end

  def privacy_setting
    _('Public profile')
  end

  def url
    "/profile/#{self.identifier}"
  end

  alias :public_profile_url :url

  def admin_url
    "http://#{self.source}/myprofile/#{self.identifier}"
  end

  def wall_url
    self.url
  end
  def tasks_url
    self.url
  end
  def leave_url(reload = false)
    self.url
  end
  def join_url
    self.url
  end
  def join_not_logged_url
    self.url
  end
  def check_membership_url
    self.url
  end
  def add_url
    self.url
  end
  def check_friendship_url
    self.url
  end
  def people_suggestions_url
    self.url
  end
  def communities_suggestions_url
    self.url
  end
  def top_url(scheme = 'http')
    "#{scheme}://#{self.source}"
  end

  def preferred_login_redirection
    environment.redirection_after_login
  end

  def location
    self.source
  end

  def default_hostname
    environment.default_hostname
  end

  def possible_domains
    environment.domains
  end

  def person?
    true
  end

  def remote?
    true
  end

  def contact_email(*args)
    self.email
  end

  def notification_emails
    [self.contact_email]
  end

  def email_domain
    self.source
  end

  def email_addresses
    ['%s@%s' % [self.identifier, self.source] ]
  end

  def jid(options = {})
    "#{self.identifier}@#{self.source}"
  end
  def full_jid(options = {})
    "#{jid(options)}/#{self.name}"
  end

  def name
    "#{self[:name]}@#{self.source}"
  end

  def diaspora_handle
    "#{self[:identifier]}@#{self.source}"
  end

  def public_key
    OpenSSL::PKey::RSA.new(self[:public_key])
  end

  class ExternalPerson::Image
    def initialize(path)
      @path = path
    end

    def public_filename(size = nil)
      URI.join(@path, size.to_s)
    end

    def content_type
      # This is not really going to be used anywhere that matters
      # so we are hardcodding it here.
      'image/png'
    end
  end

  def image
    ExternalPerson::Image.new(avatar)
  end

  def allow_followers
    true
  end

  alias_method :allow_followers?, :allow_followers

  def data_hash(gravatar_default = nil)
    friends_list = {}
    {
      'login' => self.identifier,
      'name' => self.name,
      'email' => self.email,
      'avatar' => self.profile_custom_icon(gravatar_default),
      'is_admin' => self.is_admin?,
      'since_month' => self.created_at.month,
      'since_year' => self.created_at.year,
      'email_domain' => self.source,
      'friends_list' => friends_list,
      'enterprises' => [],
      'amount_of_friends' => friends_list.count,
      'chat_enabled' => false
    }
  end

  # External Person should respond to all methods in Person and Profile
  def person_instance_methods
    methods_and_responses = {
     enterprises: Enterprise.none, communities: Community.none, friends:
     Person.none, memberships: Profile.none, friendships: Person.none,
     following_articles: Article.none, article_followers: ArticleFollower.none,
     requested_tasks: Task.none, mailings: Mailing.none, favorite_enterprise_people:
     FavoriteEnterprisePerson.none,
     favorite_enterprises: Enterprise.none, acepted_forums: Forum.none,
     articles_with_access: Article.none, suggested_profiles:
     ProfileSuggestion.none, suggested_people: ProfileSuggestion.none,
     suggested_communities: ProfileSuggestion.none, user: nil,
     refused_communities: Community.none, has_permission?: false,
     has_permission_with_admin?: false, has_permission_without_admin?: false,
     has_permission_with_plugins?: false, has_permission_without_plugins?:
     false, memberships_by_role: Person.none, can_change_homepage?: false,
     can_control_scrap?: false, receives_scrap_notification?: false,
     can_control_activity?: false, can_post_content?: false,
     suggested_friend_groups: [], friend_groups: [], add_friend: nil,
     already_request_friendship?: false, remove_friend: nil,
     presence_of_required_fields: nil, active_fields: [], required_fields: [],
     signup_fields: [], default_set_of_boxes: [], default_set_of_articles: [],
     cell_phone: nil, comercial_phone: nil, nationality: nil, schooling: nil,
     contact_information: nil, sex: nil, birth_date: nil, jabber_id: nil,
     personal_website: nil, address_reference: nil, district: nil,
     schooling_status: nil, formation: nil, custom_formation: nil, area_of_study: nil,
     custom_area_of_study: nil, professional_activity: nil, organization_website: nil,
     organization: nil, photo: nil, city: nil, state: nil, country: nil, zip_code: nil,
     address_line2: nil, copy_communities_from: nil, private_key: nil,
     has_organization_pending_tasks?: false, organizations_with_pending_tasks:
     Organization.none, pending_tasks_for_organization: Task.none,
     build_contact: nil, is_a_friend?: false, ask_to_join?: false, refuse_join:
     nil, blocks_to_expire_cache: [], cache_keys: [], communities_cache_key: '',
     friends_cache_key: '', manage_friends_cache_key: '', relationships_cache_key: '',
     is_member_of?: false, :allow_followers= => true, in_social_circle?: false,
     each_friend: nil, is_last_admin?: false, is_last_admin_leaving?: false,
     leave: nil, last_notification: nil, notification_time: 0, notifier: nil,
     remove_suggestion: nil, allow_invitation_from?: false,
     tracked_actions: ActionTracker::Record.none, follow: [],
     update_profile_circles: ProfileFollower.none, unfollow: ProfileFollower.none,
     remove_profile_from_circle: ProfileFollower.none, followed_profiles: Profile.none
    }

    derivated_methods = generate_derivated_methods(methods_and_responses)
    derivated_methods.merge(methods_and_responses)
  end

  def method_missing(method, *args, &block)
    if person_instance_methods.keys.include?(method)
      return person_instance_methods[method]
    end
    super(method, *args, &block)
  end

  def respond_to_missing?(method_name, include_private = false)
    person_instance_methods.keys.include?(method_name) ||
    super
  end

  def kind_of?(klass)
    (klass == Person) ? true : super
  end
end
