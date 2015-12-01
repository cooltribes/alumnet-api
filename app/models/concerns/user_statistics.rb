class UserStatistics
  attr_accessor :user, :init_date, :end_date, :group_by

  # group_by = "years"-"months"-"days"

  def initialize(user, init_date = nil, end_date = nil, group_by = nil)
    @user = user
    @init_date = init_date || "01-01-2015"
    @end_date = end_date || Date.today.strftime("%d-%m-%Y")
    @group_by = group_by || "days"
  end

  def get_data
    { bar_data: bar_data, column_data: column_data }
  end

  def bar_data
    data = []
    data << ["Element", "#"]
    data << ["Created Posts", created_posts.count]
    data << ["Like in Posts", likes_in_created_posts.count]
    data << ["Shared Posts", shared_created_posts.count]
    data
  end

  def column_data
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

  def created_posts
    @cache_created_post ||= user.publications.where(created_at: interval)
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
    (Date.parse(init_date)..Date.parse(end_date)).map { |d| d.strftime(intvl) }.uniq if interval
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
end