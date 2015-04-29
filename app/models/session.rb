class Session < ActiveRecord::Base
  belongs_to :user
  validates :session_id, presence: true, uniqueness: true

  def self.create_session(user, session_id)
    if Session.find_by(:session_id => session_id).nil?
      Session.create(:user_id => user.id, :session_id => session_id, :expires => DateTime.now + 60, :ip => user.last_ip, :guest => false )
    else
      reset_session
      flash[:danger] = "Сессия существует, перезаписываем."
    end
  end

  def self.destroy_session(session_id)
    unless Session.find_by(:session_id => session_id).nil?
      Session.find_by(:session_id => session_id).update(:expires => DateTime.now)
    else
      flash[:danger] = "Сессии не существует."
    end
  end

end
