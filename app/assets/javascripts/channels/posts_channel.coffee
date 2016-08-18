postsChannelFunctions = () ->

  checkMe = (comment_id, username) ->
    unless $('meta[name=admin]').length > 0 || $("meta[user=#{username}]").length > 0
           $(".border[data-id=#{comment_id}] .control-panel").remove()

  createComment = (data) ->
    if $('#comment-index').data().id == data.post.id
       $('#comments').prepend(data.partial)
       checkMe(data.comment.id)

  updateComment = (data) ->
    if $('#comment-index').data().id == data.post.id
       $(".border[data-id=#{data.comment.id}]").replaceWith(data.partial)
       checkMe(data.comment.id)

  destroyComment = (data) ->
    if $('#comment-index').data().id == data.post.id
       $(".border[data-id=#{data.comment.id}]").remove()

  if $('#comment-index').length > 0
    App.posts_channel = App.cable.subscriptions.create {
      channel: "PostsChannel"
    },
    connected: () -> console.log("asdasdsadas")

    disconnected: () ->

    received: (data) ->
        switch data.type
          when "create" then createComment(data)
          when "update" then updateComment(data)
          when "destroy" then destroyComment(data)


$(document).on 'turbolinks:load', postsChannelFunctions
