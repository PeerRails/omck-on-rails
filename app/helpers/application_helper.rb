module ApplicationHelper
  
  def create_session(user, session_id)
    Session.create(:user_id => user.id, :session_id => session_id, :expires => DateTime.now + 60, :ip => user.last_ip, :guest => false )
  end

  def current_user=(user)
          @current_user = user
  end

  def current_user
          current_session ||= Session.find_by_session_id(session[:session_id])
          current_user ||= User.find(current_session.user_id) if !current_session.nil?
  end
end
