class VoteBroadcastJob < ApplicationJob
  queue_as :default

  def perform(comment)
    ActionCable.server.broadcast 'votes_channel', comment_id: comment.id, likes: comment.total_likes, dislikes: comment.total_dislikes
  end
end
