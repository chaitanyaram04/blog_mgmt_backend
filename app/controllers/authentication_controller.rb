class AuthenticationController < ApplicationController


    def admin
      @users = User.all  
    end

    def signup
      user = User.new(user_params)
      Rails.logger.debug "User : #{user_params.inspect}"
      if user.save
        Rails.logger.debug "User : #{user.inspect}"
        token = encode(user_id: user.id)
        render json: { token: token, user: user  }, status: :created

      else
        Rails.logger.debug "User errors: #{user.errors.full_messages}"

        render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
      end
    end
    
    def signin
      user = User.find_by(email: params[:email])
    
      if user&.authenticate(params[:password])
        token = encode(user_id: user.id)
        render json: { token: token, user: user }
      else
        render json: { errors:"Invalid Email Or Password!!!! Try again" }, status: :unauthorized
      end
    end
  
    def signout
      render json: { message: 'Signed out successfully' }, status: :ok
    end
  
    private
  
    def user_params
      params.permit(:user_name, :email, :password, :role)
    end

  end
  