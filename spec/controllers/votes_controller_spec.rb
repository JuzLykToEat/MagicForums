require 'rails_helper'

RSpec.describe VotesController, type: :controller do

  before(:all) do
    @user = User.create({username: "Adam", password: "12345", email: "adam@email.com", id: 1})
    @user2 = User.create({username: "Boey", password: "54321", email: "boey@email.com", id: 2})
    @comment = Comment.create({body: "Example body", user_id: 1, id: 1})
    @comment2 = Comment.create({body: "Example body", user_id: 1, id: 2})
    @vote = Vote.create({like: 1, user_id:2, comment_id: 1})
    @vote2 = Vote.create({like: -1, user_id:2, comment_id: 2})
  end

  describe "upvote" do

    it "should redirect if not logged in" do

      params = { comment_id: @comment.id }
      post :upvote, params: params

      expect(subject).to redirect_to(root_path)
      expect(flash[:danger]).to eql("You need to login first")
    end

    it "should upvote comment" do

      params = { comment_id: @comment.id}
      post :upvote, xhr: true, params: params, session: { id: @user.id }

      vote = @comment.votes.find_by(user_id: @user.id)
      expect(vote.like).to eql(1)
      expect(@comment.total_likes).to eql(2)
      expect(flash[:success]).to eql("You've liked a comment.")
    end

    it "should unlike comment" do

      params = { comment_id: @comment.id}
      post :upvote, xhr: true, params: params, session: { id: @user2.id }

      expect(@vote.like).to eql(1)
      binding.pry
      expect(@comment.total_likes).to eql(0)
      expect(flash[:success]).to eql("You've unliked a comment.")
    end

  end

  describe "downvote" do

    it "should redirect if not logged in" do

      params = { comment_id: @comment2.id }
      post :downvote, params: params

      expect(subject).to redirect_to(root_path)
      expect(flash[:danger]).to eql("You need to login first")
    end

    it "should downvote comment" do

      params = { comment_id: @comment2.id}
      post :downvote, xhr: true, params: params, session: { id: @user.id }

      vote = @comment2.votes.find_by(user_id: @user.id)
      expect(vote.like).to eql(-1)
      expect(@comment2.total_dislikes).to eql(2)
      expect(flash[:success]).to eql("You've disliked a comment.")
    end

    it "should unlike comment" do

      params = { comment_id: @comment2.id}
      post :downvote, xhr: true, params: params, session: { id: @user2.id }

      expect(@vote2.like).to eql(-1)
      expect(@comment2.total_dislikes).to eql(0)
      expect(flash[:success]).to eql("You've un-disliked a comment.")
    end

  end


end
