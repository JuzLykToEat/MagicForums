votesChannelFunctions = () ->

    if $('#comment-index').length > 0
      App.posts_channel = App.cable.subscriptions.create {
        channel: "VotesChannel"
      },
      connected: () ->

      disconnected: () ->

      received: (data) ->
        if $('#comment-index').data().id == data.post.id
           $(".border[data-id=#{data.comment.id}]").replaceWith(data.partial)

  $(document).on 'turbolinks:load', votesChannelFunctions
