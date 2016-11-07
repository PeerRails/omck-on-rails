class SessionController < ApplicationController

    # Show login page
    def login
        respond_to do |format|
            format.html {render "session/login"}
        end
    end

    # Authorize client and save his session
    def enter
        client = Client.find_by_email(login_params[:email])
        if client && client.valid_password?(login_params[:password])
            Session.create_session(client, session[:session_id])
        end
        redirect_to login_path
    end

    # Register new client or redirect to login
    def register
        client = Client.new(name: login_params[:name], email: login_params[:email])
        if client.save
            EmailConfirmationToken.create(client_id: client.id)
            # Should send new password
            # send_mail_with_first_password
            redirect_to login_path
        else
            redirect_to login_path
        end
    end

    def logout
        Session.destroy_session(session[:session_id])
        redirect_to login_path
    end

    def verify_email
        token = EmailConfirmationToken.where(secret: params[:token]).first
        if token && !token.confirmed
            token.update_client
            @message = "ты пидор"
        end
    end

    # Get forgot_password, page for this
    def forgot_password
    end

    # Restore password for client
    def restore_password
        client = Client.find_by_email(login_params[:email])
        client.salt_password
        client.save
        # Should send new password
        # send_mail_with_new_password
        flash[:notice] = "Password changed"
        redirect_to login_path
    end

    # Change password for user, post action
    # @param email [String]
    def change_password
        client = Client.find_by_email(login_params[:email])
        client.salt_password
        client.save
        # Should send new password
        # send_mail_with_new_password
        flash[:notice] = "Password changed, check email"
        redirect_to login_path
    end

    # Change email for user, post action
    # @param email [String]
    # @param new_email [String]
    def change_email
        client = Client.find_by_email(params[:email])
        token = EmailChangeToken.create(client_id: client.id, old_email: params[:email], new_email: params[:new_email])
        puts token.new_email
        # Should send new token
        # send_mail_with_new_password
        flash[:notice] = "Check email for confimation"
        redirect_to login_path
    end

    def verify_email_change
        token = EmailChangeToken.where(secret: params[:token]).first
        if token && !token.confirmed
            token.update_email
            @message = "ты пидор"
        end
    end


    def login_params
        params.permit(:email, :password, :name)
    end
end
