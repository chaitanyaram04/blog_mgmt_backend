class LikesController < ApplicationController
    include GetUser
    

    def count
        likeable = find_likeable
        Rails.logger.debug "Decoded JWT payload method: #{params.inspect}"

        if likeable.nil?
            render json: { errors: "Check Again" }, status: :not_found
        else
            render json: { likes: likeable.likes.count }, status: :ok
        end
    end
    def create
      ActiveRecord::Base.transaction do
        likeable = find_likeable
        if likeable.nil?
          render json: { errors: "Check Again" }, status: :not_found
        else
          @like = likeable.likes.new(user: @current_user)
          if @like.save
            if likeable.is_a?(Blog)
              user_ids = likeable.likes.pluck(:user_id)
              user_names = User.where(id: user_ids).pluck(:user_name)
            else
              user_names = []
            end
    
            render json: { 
              likes: likeable.likes.count, 
              like_id: @like.id, 
              user_names: user_names 
            }, status: :created
          else
            raise ActiveRecord::Rollback
          end
        end
      end
    rescue => e
      render json: { errors: e.message }, status: :unprocessable_entity
    end
    
    

    
    def destroy
        ActiveRecord::Base.transaction do
          likeable = find_likeable
          like = Like.find_by(id: params[:id])
          user = get_current_user
          if like.nil?
            render json: { errors: "Like not found" }, status: :not_found
          elsif like.user != user
            render json: { errors: "Unauthorized" }, status: :unauthorized
          else
            if like.destroy
              render json: { likes: likeable.likes.count }, status: :ok
            else
              raise ActiveRecord::Rollback
            end
          end
        end
      rescue => e
        render json: { errors: e.message }, status: :unprocessable_entity
      end

    private
    
    def find_likeable
        if params[:blog_id]
        Blog.find_by(id: params[:blog_id])
        elsif params[:comment_id]
        Comment.find_by(id: params[:comment_id])
        else
        nil
        end
    end

    def like_params
        params.permit(:blog_id, :comment_id, :user_name)
    end

end
