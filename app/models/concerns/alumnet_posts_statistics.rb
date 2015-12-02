class AlumnetPostsStatistics
  attr_accessor :init_date, :end_date, :group_by

  # group_by = "years"-"months"-"days"

  def initialize(init_date = (Date.today - 7), end_date = Date.today, group_by = nil)
    @init_date = parse_date(init_date)
    @end_date = parse_date(end_date)
    @group_by = group_by || "days"
  end

  def get_data
    { total: total, data_by_date: data_by_date, data_by_users: data_by_users }
  end

  def total
    data = []
    data << ["Type", "Cant."]
    data << ["Created Posts", created_posts.count]
    data << ["Comments", comments.count]
    data << ["Likes", likes_in_created_posts.count]
    data << ["Shared Posts", shared_created_posts.count]
    data
  end

  def data_by_date
    data = []
    created_posts_grouped = group_by_created(created_posts)
    comments_grouped = group_by_created(comments)
    likes_in_created_posts_grouped = group_by_created(likes_in_created_posts)
    shared_created_posts_grouped = group_by_created(shared_created_posts)
    data << [@group_by, "Created Posts", "Comments", "Likes", "Shared Posts"]
    date_keys.each do |date|
      data << [date, created_posts_grouped[date] || 0, comments_grouped[date] || 0, likes_in_created_posts_grouped[date] || 0, shared_created_posts_grouped[date] || 0]
    end
    data
  end

  def data_by_users
    data = []
    data << ["Type", "Users"]
    data << ["Created Posts", group_by_user(created_posts)]
    data << ["Comments", group_by_user(comments)]
    data << ["Likes", group_by_user(likes_in_created_posts)]
    data << ["Shared Posts", group_by_user(shared_created_posts)]
    data
  end

  def created_posts
    @cache_created_post ||= Post.where(created_at: interval).where.not(post_type: "share")
  end

  def comments
    @cache_comments ||= Comment.where(created_at: interval)
  end

  def likes_in_created_posts
    @cache_like_in_created_posts ||= Like.joins("INNER JOIN posts ON posts.id = likes.likeable_id")
    .where(likeable_type: "Post", posts: { created_at: interval })
  end

  def shared_created_posts
    @cache_shared_created_posts ||= Post.where(post_type: "share", created_at: interval)
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
      else "%Y-%m-%d"
    end
  end

  def group_by_created(collection)
    result = collection.group_by { |c| c.created_at.strftime(intvl) }
    result.each { |k,v| result[k] = v.size }
  end

  def group_by_user(collection)
    collection.group_by { |c| c.user_id }.size
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