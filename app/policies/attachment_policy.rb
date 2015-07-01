class AttachmentPolicy < ApplicationPolicy

  def index?
    true
  end

  def show?
    true
  end

  def create?
    if record.folder.folderable_type == "Group"
      record.folder.folderable.user_can_upload_file(user)
    else
      true
    end
  end

  def update?
    record.uploader == user
  end

  def destroy?
    record.uploader == user
  end

end