votesChannelFunctions = () ->

  if $('#comment-index').length > 0
    App.posts_channel = App.cable.subscriptions.create {
      channel: "VotesChannel"
    },
    connected: () ->

    disconnected: () ->

    received: (data) ->
      $(".border[data-id=#{data.comment_id}] .likes-description").html(data.likes)
      $(".border[data-id=#{data.comment_id}] .dislikes-description").html(data.dislikes)

$(document).on 'turbolinks:load', votesChannelFunctions
