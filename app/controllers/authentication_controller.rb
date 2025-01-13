class AuthenticationController < ApplicationController
    include JwtHelper
  
    def signup
      user = User.new(user_params)
      Rails.logger.debug "User : #{user_params.inspect}"
      #User : #<ActionController::Parameters {"user_name"=>"chaitu_ram", "email"=>"c12wsssgdsdwsssssds3@esxample.com", "password"=>"pass12s", "role"=>"user"} permitted: true>
     # User : #<ActionController::Parameters {"user_name"=>"Chaitanya Ram", "email"=>"demo@gmail.com", "password"=>"123456", "role"=>"user"} permitted: true>
      if user.save
        Rails.logger.debug "User : #{user.inspect}"
        token = encode(user_id: user.id)
        render json: { token: token, user: user  }, status: :created

      else
        Rails.logger.debug "User errors: #{user.errors.full_messages}"

        render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
      end
    end
  

    
    #Unpermitted parameter: :authentication. Context: { controller: AuthenticationController, action: signup, request: #<ActionDispatch::Request:0x00000001263d3660>, params: {"user_name"=>"chaitu_ram", "email"=>"c12wsssgdsdwsds3@esxample.com", "password"=>"[FILTERED]", "role"=>"user", "controller"=>"authentication", "action"=>"signup", "authentication"=>{"user_name"=>"chaitu_ram", "email"=>"c12wsssgdsdwsds3@esxample.com", "password"=>"[FILTERED]", "role"=>"user"}} }
    #Unpermitted parameter: :authentication. Context: { controller: AuthenticationController, action: signup, request: #<ActionDispatch::Request:0x000000011ec70960>, params: {"user_name"=>"Chaitanya Ram", "email"=>"demo@gmail.com", "password"=>"[FILTERED]", "role"=>"user", "controller"=>"authentication", "action"=>"signup", "authentication"=>{"user_name"=>"Chaitanya Ram", "email"=>"demo@gmail.com", "password"=>"[FILTERED]", "role"=>"user"}} }
    
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
  