class UsersController < ApplicationController

    def new
        @user = User.new
        render new
    end

    def create
       @user= User.new(user_params)
        if @user.save 
            redirect_to cats_url
        else
            render json: errors.full_messages, status: 422
        end
    end
end
