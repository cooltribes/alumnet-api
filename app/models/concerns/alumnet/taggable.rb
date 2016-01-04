module Alumnet
  # this modules are for user tagging
  module Taggable
    extend ActiveSupport::Concern

    included do
      has_many :user_taggings, as: :taggable, dependent: :destroy
      has_many :user_tags, through: :user_taggings, source: :user
    end

    def add_user_tags(user_ids, options = {})
      return if user_ids.blank?
      tagger = options.delete(:tagger)
      position = options.delete(:position)
      user_ids = process_user_ids(user_ids)
      user_ids.each do |user_id|
        attrs = { user_id: user_id, tagger: tagger, position: position }
        user_taggings.create(attrs) unless user_taggings.exists?(user_id: user_id, tagger: tagger)
      end
      true
    end

    def remove_user_tags(user_ids)
      return if user_ids.blank?
      user_ids = process_user_ids(user_ids)
      user_ids.each do |user_id|
        user_tag = user_taggings.find_by(user_id: user_id)
        user_taggings.destroy(user_tag) if user_tag
      end
      true
    end

    def update_user_tags(user_ids, options = {})
      return if user_ids.blank?
      user_ids = process_user_ids(user_ids)
      current_user_tag_ids = user_tag_ids
      # Se van a agregar los id de user_ids que no esten en current_user_tag_ids
      ids_to_add = user_ids.reject { |id| current_user_tag_ids.include?(id) }
      # Se van a eliminar los id de current_user_tag_ids que no esten user_ids
      ids_to_remove = current_user_tag_ids.reject { |id| user_ids.include?(id) }
      ## Remove
      add_user_tags(ids_to_add, options)
      remove_user_tags(ids_to_remove)
    end

    def process_user_ids(user_ids)
      array = if user_ids.is_a?(String)
        user_ids.split(",")
      elsif user_ids.is_a?(Integer)
        [user_ids]
      else
        user_ids
      end
      array.map(&:to_i)
    end
  end
end