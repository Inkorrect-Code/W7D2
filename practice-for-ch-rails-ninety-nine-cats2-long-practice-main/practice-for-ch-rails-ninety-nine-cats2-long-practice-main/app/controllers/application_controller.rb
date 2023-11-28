# CR(R)LLL - ApplicationController
    # current_user
    # require_logged_in
    # require_logged_out
    # login!(user)
    # logged_in?
    # logout


class ApplicationController < ActionController::Base
    helper_method :current_user

    def current_user
        @current_user ||= User.find_by(session_token: session[:session_token])
    end

    def logged_in
        !!current_user # '!!' makes this a hard boolean
    end

    def login!(user)
        session[:session_token] = user.reset_session_token!
    end

    def require_logged_in
        redirect to new_session_url unless logged_in?
    end

    def require_logged_out
        redirect to cats_url if logged_in?
    end
end