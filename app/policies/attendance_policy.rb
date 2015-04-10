class AttendancePolicy < ApplicationPolicy

  def index?
    true
  end

  def create?
    true
  end

  def update?
    record.user == user
  end

  def destroy?
    record.event.is_admin?(user)
  end

end