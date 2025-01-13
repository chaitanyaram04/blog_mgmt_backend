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
        likeable = find_likeable
        if likeable.nil?
            render json: { errors: "Check Again" }, status: :not_found
        else
            @like = likeable.likes.new(user: @current_user)
            if @like.save
              render json:{ likes: likeable.likes.count, like_id: @like.id }, status: :created
            else
              render json: { errors: @like.errors.full_messages }, status: :unprocessable_entity
            end
        end
    end
    def destroy
        likeable = find_likeable
        like = Like.find_by(id: params[:id])
        user = @current_user
        if like.nil?
            render json: { errors: "Like not found" }, status: :not_found
        elsif like.user != user

            render json: { errors: "Unauthorized" }, status: :unauthorized
        else
            like.destroy
            render json: {likes: likeable.likes.count }, status: :ok
        end
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
        params.permit(:blog_id, :comment_id)
    end

end
