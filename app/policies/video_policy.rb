# Policy for API Video
class VideoPolicy < ApplicationPolicy

    # Show permission for user to remove video
    # @return [Boolean]
    def remove?
      user.id == video.user_id or admin?
    end

    # Show permission for user to mass remove videos
    # @return [Boolean]
    def delete_by_tk?
      user.id == video.user_id or admin?
    end

    # Define record
    # @return [Video]
    def video
      @record
    end

end
