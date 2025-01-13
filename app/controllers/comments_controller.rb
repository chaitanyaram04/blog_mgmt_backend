class CommentsController < ApplicationController
    include GetUser

    def create
        @blog = Blog.find(comm_params[:blog_id])
        if @blog
            @comment = @blog.comments.new(content: comm_params[:content])
            @comment.user = get_current_user

            if @comment.save
                render json: @comment, status: :created
            else 
                render json: { errors: @comment.errors.full_messages}, status: :unprocessable_entity
            end 
        else 
            render json: {erroes: "No blog"}, status: :unprocessable_entity
        end
    end


    def index
        @blog = Blog.find(params[:blog_id])
        if @blog
        offset = params[:offset].to_i || 0
        limit = params[:limit].to_i || 5
        @comments = @blog.comments.offset(offset).limit(limit)
        render json: @comments, status: :ok
        else
        render json: { errors: "No blog found" }, status: :unprocessable_entity
        end
    end
      
    def update
        @comment = Comment.find(params[:id])
        if @comment.user == get_current_user
          if @comment.update(content: comm_params[:content])
            render json: @comment, status: :ok
          else
            render json: { errors: @comment.errors.full_messages }, status: :unprocessable_entity
          end
        else
          render json: { errors: "Unauthorized" }, status: :unauthorized
        end
      end
    

    def destroy
        @blog = Blog.find(comm_params[:blog_id])
        @comment = @blog.comments.find_by(id: params[:id])
        if @comment && (@comment.user_id == get_current_user.id ||get_current_user.id == @blog.user_id)
                @comment.destroy
                render json: { message: "Comment successfully deleted"}, status: :ok
        else 
            render json: {message:"Unable to delete the comment"}, status: :unprocessable_entity
        end
    end

    private
    def comm_params
        params.permit(:content,:blog_id,:id, :offset, :limit)
    end
end
