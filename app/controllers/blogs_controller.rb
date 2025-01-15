class BlogsController < ApplicationController
    include GetUser
  
    def index
      @blogs = Blog.active.all
      render json: @blogs
    end
  
    def draft
      @blogs = @current_user.blogs.drafted.all
      if @blogs.present?
        render json: @blogs
      else
        render json: { errors: "There are no blogs for this user" }, status: :not_found
      end
    end
  
    def archive
      @blogs = @current_user.blogs.deleted.all
      if @blogs.present?
        render json: @blogs
      else
        render json: { error: "There are no archive for this user" }, status: :not_found
      end
    end
  
    def shows
      @blogs = @current_user.blogs.published.all
      if @blogs.present?
        render json: @blogs
      else
        render json: { error: "There are published blogs for this user" }, status: :not_found
      end
    end
  
    def show
      @blog = Blog.find(params[:id])
      if @blog
        render json: @blog
      else
        render json: { error: 'Blog not found e' }, status: :not_found
      end
    end
  
    def destroy
      begin
        @blog = Blog.find(params[:id])
        user = @current_user
        if @blog.user_id == user.id || user.role == 'admin'
          ActiveRecord::Base.transaction do
            if @blog.update(is_deleted: true)
              render json: { message: "Successfully deleted the blog" }
            else
              raise ActiveRecord::Rollback
            end
          end
        else
          render json: { error: 'Unauthorized' }, status: :unauthorized
        end
      rescue ActiveRecord::RecordNotFound
        render json: { error: 'Blog not found' }, status: :not_found
      rescue => e
        render json: { error: e.message }, status: :unprocessable_entity
      end
    end
  
    def update
      begin
        @blog = Blog.find(params[:id])
        user = @current_user
  
        if @blog.user_id == user.id || user.role == 'admin'
          ActiveRecord::Base.transaction do
            if @blog.update(blog_params)
              render json: @blog
            else
              raise ActiveRecord::Rollback
            end
          end
        else
          render json: { error: 'Unauthorized' }, status: :unauthorized
        end
      rescue ActiveRecord::RecordNotFound
        render json: { error: 'Blog not found' }, status: :not_found
      rescue => e
        render json: { error: e.message }, status: :unprocessable_entity
      end
    end
    

    def search
      query = blog_params[:query]
      Rails.logger.info("query: #{query}")
      @blogs = Blog.published.search_by_title(query)
      if @blogs.present?
        render json: @blogs
      else
        render json: { error: "No blogs found for this query" }, status: :not_found
      end
    end

    def getAuthorBlogs
      author_id = params[:id]
      @user = User.find(author_id)
      Rails.logger.info("author_id: #{author_id}")
      @blogs = @user.blogs.published.all
      # @blogs = Blog.blogs.published.where(user_id: author_id)
      if @blogs.present?
      render json: @blogs
      else
      render json: { error: "No published blogs found for this author" }, status: :not_found
      end
    end
    
    def create
      user = @current_user
      if user.nil?
        render json: { error: 'Not logged in' }, status: :unauthorized
        return
      end
  
      ActiveRecord::Base.transaction do
        @blog = user.blogs.build(blog_params.merge(is_deleted: false))
        if @blog.save
          render json: @blog, status: :created
        else
          raise ActiveRecord::Rollback
        end
      end
    rescue => e
      render json: { error: e.message }, status: :unprocessable_entity
    end
  
    def comment
      begin
        @blog = Blog.find(params[:id])
        @comments = @blog.comments
        if @comments.present?
          render json: @comments
        else
          render json: { error: "No comments found for this blog" }, status: :not_found
        end
      rescue ActiveRecord::RecordNotFound
        render json: { error: 'Blog not found' }, status: :not_found
      end
    end
  
    private
  
    def blog_params
      params.require(:blog).permit(:title, :description, :status, :is_deleted, :user_id, :query)
    end
  end