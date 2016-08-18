class VotesController < ApplicationController
  respond_to :js
  before_action :authenticate!
  before_action :find_or_create_vote

  def upvote
    if @vote.like == 1
      value = 0
      flash.now[:success] = "You've unliked a comment."
    else
      value = 1
      flash.now[:success] = "You've liked a comment."
      @liked = "btn-info"
    end

    update_vote(value)
  end

  def downvote
    if @vote.like == -1
      value = 0
      flash.now[:success] = "You've un-disliked a comment."
    else
      value = -1
      flash.now[:success] = "You've disliked a comment."
      @disliked = "btn-info"
    end

    update_vote(value)
  end

  private

  def find_or_create_vote
    @vote = current_user.votes.find_or_create_by(comment_id: params[:comment_id])
    @liked, @disliked = "btn-primary", "btn-primary"
  end

  def update_vote(value)
    if @vote
      @vote.update(like: value)
      VoteBroadcastJob.perform_later(@vote.comment)
    end
  end
end
