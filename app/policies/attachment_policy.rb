class AttachmentPolicy < ApplicationPolicy

  def index?
    true
  end

  def show?
    true
  end

  def create?
    if record.folder.folderable_type == "Group"
      record.folder.folderable.user_can_upload_file?(user)
    elsif record.folder.folderable_type == "Event"
      record.folder.folderable.is_admin?(user)
    else
      false
    end
  end

  def update?
    
    return true if record.uploader == user    

    if record.folder.folderable_type == "Group"
      record.folder.folderable.user_is_admin?(user)
    elsif record.folder.folderable_type == "Event"
      record.folder.folderable.is_admin?(user)
    else
      false
    end

  end

  def destroy?
    return true if record.uploader == user    

    if record.folder.folderable_type == "Group"
      record.folder.folderable.user_is_admin?(user)
    elsif record.folder.folderable_type == "Event"
      record.folder.folderable.is_admin?(user)
    else
      false
    end
  end

end