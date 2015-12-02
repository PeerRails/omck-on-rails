class Session < ActiveRecord::Base
  belongs_to :user
  validates :session_id, presence: true, uniqueness: true
  scope :is_guest, -> { where(guest: true) }
  scope :is_user, -> { where(guest: false) }

  def self.create_session(user, session_id)
    if Session.find_by(:session_id => session_id).nil?
      Session.create(:user_id => user.id, :session_id => session_id, :expires => DateTime.now + 60, :ip => user.last_ip, :guest => false )
      return {action: "success"}
    else
      return {action: "reset_session", message: "Сессия существует, перезаписываем."}
    end
  end

  def self.destroy_session(session_id)
    unless Session.find_by(:session_id => session_id).nil?
      Session.find_by(:session_id => session_id).update(:expires => DateTime.now)
      return {action: "success", message: "Сессия сброшена."}
    else
      return {action: "cant_destroy", message: "Сессия не найдена."}
    end
  end

end
