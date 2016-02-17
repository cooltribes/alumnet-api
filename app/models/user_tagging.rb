class UserTagging < ActiveRecord::Base
  serialize :position, Hash

  ### Relations
  belongs_to :user
  belongs_to :tagger, class_name: 'User'
  belongs_to :taggable, polymorphic: true

  ### Callbacks
  after_save :send_notification

  ### Instance Methods

  ## this the logic to return the body of notification. Temp!
  def notification_body
    case taggable_type
    when "Comment"
      body_for_comment
    else
      "Mentioned you in a #{taggable_type}"
    end
  end

  def body_for_comment
    if taggable.commentable.present?
      if taggable.commentable.is_a?(Post)
        body_for_comment_in_post
      elsif taggable.commentable.is_a?(Picture)
        body_for_comment_in_picture
      end
    end
  end

  def body_for_comment_in_post
    post = taggable.commentable
    if post.postable_type == "Group" || post.postable_type == "Event"
      "Mentioned you in a #{taggable_type} in a #{taggable.commentable_type} in the #{post.postable_type} #{post.postable.name}"
    elsif post.postable_type == "User"
      # Si el usuario al que se esta tageando(tagged) es el creador del post
      if user == post.user
        "Mentioned you in a #{taggable_type} in a #{taggable.commentable_type} in your timeline"
      # Si el usuario que esta tageando(tagger) es el creador del post
      elsif taggable.user == post.user
        "Mentioned you in a #{taggable_type} in a #{taggable.commentable_type} in #{taggable.user.profile.pronoun} timeline"
      else
        "Mentioned you in a #{taggable_type} in a #{taggable.commentable_type} in #{post.postable.name} timeline"
      end
    end
  end

  def body_for_comment_in_picture
    picture = taggable.commentable
    "Mentioned you in a #{taggable_type} of Picture #{picture.title}"
  end

  private
    def send_notification
      Notification.notify_tagging(self)
    end
end