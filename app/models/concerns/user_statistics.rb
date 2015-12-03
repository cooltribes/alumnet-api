class UserStatistics
  attr_accessor :user, :init_date, :end_date, :group_by

  # group_by = "years"-"months"-"days"

  def initialize(user, init_date = (Date.today - 7), end_date = Date.today, group_by = nil)
    @user = user
    @init_date = parse_date(init_date)
    @end_date = parse_date(end_date)
    @group_by = group_by || "days"
  end

  def get_data
    { influence_total: influence_total, influence_detail: influence_detail,
      activity_total: activity_total, activity_detail: activity_detail }
  end

  def influence_total
    data = []
    data << ["Element", "Total"]
    data << ["Created Posts", created_posts.count]
    data << ["Like in Posts", likes_in_created_posts.count]
    data << ["Shared Posts", shared_created_posts.count]
    data
  end

  def activity_total
    data = []
    data << ["Element", "Total"]
    data << ["Created Posts", created_posts.count]
    data << ["Created Likes", created_likes.count]
    data << ["Created Comments", created_comments.count]
    data << ["Created Shared Posts", created_shared_posts.count]
    data
  end

  def influence_detail
    data = []
    created_posts_grouped = group_collection(created_posts)
    likes_in_created_posts_grouped = group_collection(likes_in_created_posts)
    shared_created_posts_grouped = group_collection(shared_created_posts)
    data << [@group_by, "Created Posts", "Like in Posts", "Shared Posts"]
    date_keys.each do |date|
      data << [date, created_posts_grouped[date] || 0, likes_in_created_posts_grouped[date] || 0, shared_created_posts_grouped[date] || 0]
    end
    data
  end

  def activity_detail
    data = []
    created_posts_grouped = group_collection(created_posts)
    created_likes_grouped = group_collection(created_likes)
    created_comments_grouped = group_collection(created_comments)
    created_shared_grouped = group_collection(created_shared_posts)
    data << [@group_by, "Created Posts", "Created Likes", "Created Comments", "Created Shared Posts"]
    date_keys.each do |date|
      data << [date, created_posts_grouped[date] || 0, created_likes_grouped[date] || 0, created_comments_grouped[date] || 0, created_shared_grouped[date] || 0]
    end
    data
  end

  def created_posts
    @cache_created_post ||= user.publications.where(post_type: "regular", created_at: interval)
  end

  def created_shared_posts
    @cache_shared ||= user.publications.where(post_type: "share", created_at: interval)
  end

  def created_likes
    @cache_created_likes ||= user.likes.where(created_at: interval)
  end

  def created_comments
    @cache_created_comments ||= user.comments.where(created_at: interval)
  end

  def likes_in_created_posts
    @cache_like_in_created_posts ||= Like.joins("INNER JOIN posts ON posts.id = likes.likeable_id")
    .where(likeable_type: "Post", posts: { user_id: user.id })
    .where(posts: { created_at: interval })
  end

  def shared_created_posts
    posts_ids = user.publications.pluck(:id)
    @cache_shared_created_posts ||= Post.where(post_type: "share", content_type: "Post", content_id: posts_ids)
    .where(created_at: interval)
  end

  private

  def date_keys
    interval.map { |d| d.strftime(intvl) }.uniq if interval
  end

  def interval
    (init_date..end_date)
  end

  def intvl
    case group_by.downcase
      when "days" then "%d-%m-%Y"
      when "months" then "%m-%Y"
      when "years" then "%Y"
      else "%d-%m-%Y"
    end
  end

  def group_collection(collection)
    result = collection.group_by { |c| c.created_at.strftime(intvl) }
    result.each { |k,v| result[k] = v.size }
  end

  def parse_date(date)
    if date.is_a?(String)
      Date.parse(date)
    elsif date.is_a?(Date)
      date
    else
      Date.today
    end
  end
end