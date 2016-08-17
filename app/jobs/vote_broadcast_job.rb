class VoteBroadcastJob < ApplicationJob
  queue_as :default

  def perform(comment_id)
    ActionCable.server.broadcast 'votes_channel', comment_id: comment_id, partial: render_comment_partial(comment)
  end

  private

  def render_comment_partial(comment)
    CommentsController.render partial: "comments/comment", locals: { comment: comment, post: comment.post, current_user: comment.user}
  end
end
