class User::UserController < ApplicationController

    before_action :doorkeeper_authorize!

    def me
        render json: {
            id: current_user.id,
            name: current_user.name,
            email: current_user.email
        }
    end

end