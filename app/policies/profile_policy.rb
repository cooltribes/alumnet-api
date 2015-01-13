class ProfilePolicy < ApplicationPolicy

  def create?
    user.profile == record || user.is_system_admin? || user.is_alumnet_admin?
  end

  def update?
    user.profile == record || user.is_system_admin? || user.is_alumnet_admin?
  end

  def destroy?
    user.profile == record || user.is_system_admin? || user.is_alumnet_admin?
  end
end