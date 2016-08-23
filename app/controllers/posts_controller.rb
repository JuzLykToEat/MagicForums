class PostsController < ApplicationController
  respond_to :js
  before_action :authenticate!, only: [:create, :edit, :update, :new, :destroy]

  def index
    @topic = Topic.includes(:posts).friendly.find(params[:topic_id])
    @posts = @topic.posts.order(created_at: :desc)
    @post = Post.new
  end

  def create
    @topic = Topic.friendly.find(params[:topic_id])
    @post = current_user.posts.build(post_params.merge(topic_id: @topic.id))
    @new_post = Post.new

    if @post.save
      flash.now[:success] = "You've created a new post."
    else
      flash.now[:danger] = @post.errors.full_messages
    end
  end

  def edit
    @post = Post.friendly.find(params[:id])
    @topic = @post.topic
    authorize @post
  end

  def update
    @topic = Topic.friendly.find(params[:topic_id])
    @post = Post.friendly.find(params[:id])
    authorize @post

    if @post.update(post_params)
      flash.now[:success] = "You've edited the post."
    else
      flash.now[:danger] = @post.errors.full_messages
    end
  end

  def destroy
    @post = Post.friendly.find(params[:id])
    @topic = @post.topic
    authorize @post

    if @post.destroy
      flash[:success] = "You've deleted the post."
      redirect_to topic_posts_path(@topic)
    # else
    #   redirect_to post_path(@post)
    end
  end

  private

    def post_params
      params.require(:post).permit(:title, :body, :image)
    end

end
