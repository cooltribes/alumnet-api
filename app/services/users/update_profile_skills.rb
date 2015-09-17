module Users
  class UpdateProfileSkills
    include ActiveModel::Model

    attr_reader :profile

    def initialize(profile, skill_names)
      @profile = profile
      @skill_names = skill_names
    end

    def call
      if @skill_names.is_a?(Array)
        skill_ids = get_ids_of_skills
        @profile.skill_ids = skill_ids
        true
      else
        errors.add(:skills, "should be an array")
        false
      end
    end

    private
      def get_ids_of_skills
        @skill_names.each_with_object([]) do |skill_name, array|
          skill = Skill.find_or_create_by(name: skill_name)
          array << skill.id if skill
        end
      end
  end
end