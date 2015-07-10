class TaskAttribute < ActiveRecord::Base
  ## Relations
  belongs_to :task
  belongs_to :attributable, polymorphic: true

  ## Validations
  validates_presence_of :value, :profinda_id, :custom_field, :attribute_type

  ## Scopes
  scope :nice_have, -> { where(attribute_type: "nice_have") }
  scope :must_have, -> { where(attribute_type: "must_have") }

  ## Instance Methods

  def find_and_set_attributable
    case custom_field
      when "alumnet_skills"
        self.attributable = Skill.find_by(name: value)
      when "alumnet_languages"
        self.attributable = Language.find_by(name: value)
      when "alumnet_city_residence" || "alumnet_city_origin"
        self.attributable = City.find_by(name: value)
      when "alumnet_country_residence" || "alumnet_country_origin"
        self.attributable = Country.find_by(name: value)
      else
        nil
    end
  end

  ## Class Methods

  def self.create_from_dictionary_object(task, object, attribute_type = "nice_have")
    attributes = { value: object["value"], profinda_id: object["id"], custom_field: object["name"],
      attribute_type: attribute_type }
    task_attribute = task.task_attributes.new(attributes)
    task_attribute.tap { |ta| ta.find_and_set_attributable }.save
    task_attribute
  end
end