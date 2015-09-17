class ProfileVisit < ActiveRecord::Base
  ### Relations
  belongs_to :user
  belongs_to :visitor, class_name: "User"

  ### Class methods
  def self.create_visit(user, visitor, reference = nil)
    return if user == visitor
    visit = find_by(user: user, visitor: visitor)
    if (visit && visit.created_at < 1.day.ago) || visit.nil?
      create!(user: user, visitor: visitor, reference: reference)
    end
  end
end
