class SessionsController < ApplicationController
    def new
        @user = User.new
        render new
    end
    
    def create
        username = params[:user][:username]
        password = params[:user][:password]
        @user = User.find_by_credentials(username, password)
        if @user.save 
            redirect_to cats_url
        else
            render json: errors.full_messages, status: 422
        end
    end
end
