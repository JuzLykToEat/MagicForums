class VotesController < ApplicationController
  respond_to :js
  before_action :authenticate!

  def upvote
    vote = current_user.votes.find_or_create_by(comment_id: params[:comment_id])

    if vote.value == 1
      CommentBroadcastJob.perform_later(params[:comment_id])
      vote.update(value: 0)
      flash.now[:success] = "You've unliked a comment."
    else
      CommentBroadcastJob.perform_later(params[:comment_id])
      vote.update(value: 1)
      flash.now[:success] = "You've liked a comment."
    end
  end

  def downvote
    vote = current_user.votes.find_or_create_by(comment_id: params[:comment_id])

    if vote.value == -1
      vote.update(value: 0)
      flash.now[:success] = "You've un-disliked a comment."
      redirect_to(:back)
    else
      vote.update(value: -1)
      flash.now[:success] = "You've disliked a comment."
      redirect_to(:back)
    end
  end

end
