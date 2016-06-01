class VideoPolicy < ApplicationPolicy

  def remove?
    user.id == video.user_id or admin?
  end

  def delete_by_tk?
    user.id == video.user_id or admin?
  end

  def video
    @record
  end

end
