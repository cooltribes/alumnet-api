module PostHelpers
  include Rails.application.routes.url_helpers


  def can_edited_by(user)
    return true if user == self.user
  end

  def can_deleted_by(user)
    return true if user == self.user
  end

  def postable_info
    { type: postable_type, id: postable.id, name: postable.name } if postable.present?
  end

  def resource_path
    url_for [self.postable, self, only_path: true]
  end

  def default_url_options
    { host: Settings.api_domain}
  end
end
