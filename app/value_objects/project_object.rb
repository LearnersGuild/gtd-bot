class ProjectObject < BaseObject
  attribute :asana_id, String
  attribute :name, String
  attribute :owner_id, String
  attribute :tasks, Array

  def a_role?
    name_start_with?("@")
  end

  def underscored?
    name_start_with?("_")
  end

  def individual?
    name.present? && name == Strategies::IndividualRole::INDIVIDUAL_NAME
  end

  private

  def name_start_with?(text)
    name.present? && name.start_with?(text)
  end
end
