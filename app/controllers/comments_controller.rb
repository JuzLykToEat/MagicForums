class CommentsController < ApplicationController
  respond_to :js
  before_action :authenticate!, only: [:create, :edit, :update, :new, :destroy]

  def index
    @post = Post.includes(:comments).friendly.find(params[:post_id])
    @topic = @post.topic
    @comments = @post.comments.order(created_at: :desc).page params[:page]
    @comment = Comment.new
  end

  def create
    @post = Post.friendly.find(params[:post_id])
    @topic = @post.topic
    @comment = current_user.comments.build(comment_params.merge(post_id: @post.id))
    @new_comment = Comment.new

    if @comment.save
      CommentBroadcastJob.perform_later("create", @comment)
      flash.now[:success] = "You've created a new comment."
    else
      flash.now[:danger] = @comment.errors.full_messages
    end
  end

  def edit
    @post = Post.friendly.find(params[:post_id])
    @topic = @post.topic
    @comment = Comment.friendly.find(params[:id])
    authorize @comment
  end

  def update
    @post = Post.friendly.find(params[:post_id])
    @topic = @post.topic
    @comment = Comment.friendly.find(params[:id])

    if @comment.update(comment_params)
      CommentBroadcastJob.perform_later("update", @comment)
      flash.now[:success] = "You've edited the comment."
    else
      flash.now[:danger] = @comment.errors.full_messages
    end
  end

  def destroy
    @post = Post.friendly.find(params[:post_id])
    @topic = @post.topic
    @comment = Comment.friendly.find(params[:id])
    authorize @comment

    if @comment.destroy
      CommentBroadcastJob.perform_now("destroy", @comment)
      flash.now[:success] = "You've deleted the comment."
    # else
    #   redirect_to post_path(@post)
    end
  end

  private

    def comment_params
      params.require(:comment).permit(:body, :image)
    end


end
