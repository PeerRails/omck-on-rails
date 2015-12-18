class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def twitter
    @user = User.login_with_twitter(env['omniauth.auth'])
    if @user.persisted?
      @user.remember_me = true
      sign_in @user, event: :authentication
      redirect_to home_path
    else
      redirect_to new_user_session_path
    end
  end

  def passthru
      render :file => "#{Rails.root}/public/404.html", :status => 404, :layout => false
  end
end
