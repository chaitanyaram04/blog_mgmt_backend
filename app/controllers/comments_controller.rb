class CommentsController < ApplicationController
    include GetUser
  
    def create
      ActiveRecord::Base.transaction do
        @blog = Blog.find_by(id: comm_params[:blog_id])
        if @blog
          @comment = @blog.comments.new(content: comm_params[:content])
          @comment.user = get_current_user
  
          if @comment.save
            render json: @comment, status: :created
          else
            raise ActiveRecord::Rollback
          end
        else
          render json: { errors: "No blog found" }, status: :unprocessable_entity
        end
      end
    rescue => e
      render json: { errors: e.message }, status: :unprocessable_entity
    end
  
    def index
      @blog = Blog.find_by(id: params[:blog_id])
      if @blog
        offset = params[:offset].to_i || 0
        limit = params[:limit].to_i || 5
        @comments = @blog.comments.offset(offset).limit(limit)
        render json: @comments, status: :ok
      else
        render json: { errors: "No blog found" }, status: :unprocessable_entity
      end
    end


    def show
      @user = User.find_by(id: params[:id])
      if @user
        @comments = @user.comments
        render json: @comments, status: :ok
      else
        render json: { errors: "No user found" }, status: :unprocessable_entity
      end
    end
  
    def update
      ActiveRecord::Base.transaction do
        @comment = Comment.find_by(id: params[:id])
        if @comment
          if @comment.update(comm_params)
            render json: @comment, status: :ok
          else
            raise ActiveRecord::Rollback
          end
        else
          render json: { errors: "Comment not found" }, status: :not_found
        end
      end
    rescue => e
      render json: { errors: e.message }, status: :unprocessable_entity
    end
  

    def destroy
        @blog = Blog.find(comm_params[:blog_id])
        @comment = @blog.comments.find_by(id: params[:id])
        if @comment && (@comment.user_id == @current_user.id ||@current_user.id == @blog.user_id)
                @comment.destroy
                render json: { message: "Comment successfully deleted"}, status: :ok
        else 
            render json: {message:"Unable to delete the comment"}, status: :unprocessable_entity
        end
    end
    private
  
    def comm_params
      params.require(:comment).permit(:content, :blog_id)
    end
  end