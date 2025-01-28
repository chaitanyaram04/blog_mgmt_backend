class AdminController < ApplicationController
    before_action :set_user, only: [:edit, :update, :destroy, :updates]
  
    def admin
      @users = User.all
      render json: @users
    end
  
    def login 
    end

    def validate
      user = User.find_by(email: params[:email])
  
      if user&.authenticate(params[:password]) && user.role == 'admin'
        token = encode(user_id: user.id)
        redirect_to home_admin_path, notice: 'Welcome....'
      else
        redirect_to home_admin_login_path, alert: "Invalid credentials"
      end
    end



    
    def edit
    end
  
    def update
      Rails.logger.debug "User: #{user_params.inspect}"
    
      if user_params[:password].present? || user_params[:password_confirmation].present?
        if user_params[:password] != user_params[:password_confirmation]
          redirect_to edit_admin_path(@user), alert: "Password and confirm password do not match" and return
        end
      end
      if @user.update(user_params.except(:password_confirmation))
        redirect_to home_admin_path, notice: 'User updated successfully'
      else
        flash[:alert] = "Something went wrong. User not updated"
        render :edit, status: :unprocessable_entity
      end
    end
    
    def updates
      Rails.logger.debug "User: #{user_params.inspect}"
    
      if user_params[:password].present? || user_params[:password_confirmation].present?
        if user_params[:password] != user_params[:password_confirmation]
          redirect_to edit_admin_path(@user), alert: "Password and confirm password do not match" and return
        end
      end
      if @user.update(user_params.except(:password_confirmation))
        render json: @user
      else
        render json: { error: 'Unauthorized' }, status: :unprocessable_entity
      end
    end
    
  
    def destroy
      @user.destroy
      redirect_to home_admin_path, notice: 'User deleted successfully'
    end
  
    private
  
    def set_user
      @user = User.find(params[:id])
    end
  
    def user_params
      params.require(:user).permit(:user_name, :email, :password, :password_confirmation, :id)
    end
  end
  