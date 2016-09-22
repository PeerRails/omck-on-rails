# Policy for API Tweet
class UserPolicy < ApplicationPolicy

    # Show permission for user to grant permissions
    # @return [Boolean]
    def grant?
      admin?
    end

    # Show permission for user to invite new streamers
    # @return [Boolean]
    def invite?
      admin? or (user.id != user_record.id and streamer?)
    end

    # Define record
    # @return [User]
    def user_record
      @record
    end

end
