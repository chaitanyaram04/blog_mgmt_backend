class AdminController < ApplicationController
    before_action :set_user, only: [:edit, :update, :destroy]
  
    def admin
      @users = User.all
    end
  
    def edit
    end
  
    def update
      Rails.logger.debug "User: #{user_params.inspect}"
      if user_params[:password] != user_params[:password_confirmation]
        redirect_to edit_admin_path(@user), alert: "Password and confirm password do not match"
      else
        if @user.update(user_params)
          redirect_to home_admin_path, notice: 'User updated successfully'
        else
          flash[:alert] = "Something went wrong. User not updated"
          render :edit
        end
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
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end
  end
  