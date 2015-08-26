module UserTaggingSystem
  module Taggable
    def self.included(base)
      base.has_many :user_taggings, as: :taggable, dependent: :destroy
      base.has_many :user_tags, through: :user_taggings, source: :user

      def add_user_tags(user_ids, options = {})
        user_ids = process_user_ids(user_ids)
        tagger = options.delete(:tagger)
        user_ids.each do |user_id|
          attrs = { user_id: user_id, tagger: tagger }
          user_taggings.create(attrs) unless user_taggings.exists?(attrs)
        end
        true
      end

      def remove_user_tags(user_ids)
        user_ids = process_user_ids(user_ids)
        user_ids.each do |user_id|
          user = user_taggings.find_by(user_id: user_id)
          user_taggings.destroy(user) if user
        end
        true
      end

      def update_user_tags(user_ids, options = {})
        tagger = options.delete(:tagger)
        current_user_tag_ids = user_tag_ids
        # Se van a agregar los id de user_ids que no esten en current_user_tag_ids
        ids_to_add = user_ids.reject { |id| current_user_tag_ids.include?(id) }
        # Se van a eliminar los id de current_user_tag_ids que no esten user_ids
        ids_to_remove = current_user_tag_ids.reject { |id| user_ids.include?(id) }
        ## Remove
        add_user_tags(ids_to_add, tagger: tagger)
        remove_user_tags(ids_to_remove)
      end

      def process_user_ids(user_ids)
        if user_ids.is_a?(String)
          user_ids.split(",")
        elsif user_ids.is_a?(Integer)
          [user_ids]
        else
          user_ids
        end
      end
    end
  end

  module Tag
    def self.included(base)
      base.has_many :user_taggings, dependent: :destroy
    end
  end
end