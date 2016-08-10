class CommentsController < ApplicationController
  before_action :authenticate!, only: [:create, :edit, :update, :new, :destroy]

  def index
    # @topic = Topic.includes(:posts).find_by(id: params[:topic_id])
    # @post = @topic.posts.find_by(id: params[:post_id])
    # @comments = @post.comments.order(created_at: :desc)

    @post = Post.includes(:comments).find_by(id: params[:post_id])
    @topic = @post.topic
    @comments = @post.comments.order(created_at: :desc)
    @comment = @post.comments.find_by(id: params[:id])
  end

  def new
    @post = Post.find_by(id: params[:post_id])
    @topic = @post.topic
    @comment = Comment.new
  end

  def create
    @post = Post.find_by(id: params[:post_id])
    @topic = @post.topic
    @comment = current_user.comments.build(comment_params.merge(post_id: params[:post_id]))

    if @comment.save
      flash[:success] = "You've created a new comment."
      redirect_to topic_post_comments_path(@topic, @post)
    else
      flash[:danger] = @comment.errors.full_messages
      redirect_to new_topic_post_comment_path
    end
  end

  def edit
    @post = Post.find_by(id: params[:post_id])
    @topic = @post.topic
    @comment = Comment.find_by(id: params[:id])
    authorize @comment
  end

  def update
    @post = Post.find_by(id: params[:post_id])
    @topic = @post.topic
    @comment = Comment.find_by(id: params[:id])

    if @comment.update(comment_params)
      flash[:success] = "You've edited the comment."
      redirect_to topic_post_comments_path(@topic, @post)
    else
      flash[:danger] = @comment.errors.full_messages
      redirect_to edit_topic_post_comment_path(@topic, @post, @comment)
    end
  end

  def destroy
    @post = Post.find_by(id: params[:post_id])
    @topic = @post.topic
    @comment = Comment.find_by(id: params[:id])
    authorize @comment

    if @comment.destroy
      flash[:success] = "You've deleted the comment."
      redirect_to topic_post_comments_path(@topic, @post)
    # else
    #   redirect_to post_path(@post)
    end
  end

  private

    def comment_params
      params.require(:comment).permit(:body, :image)
    end


end
