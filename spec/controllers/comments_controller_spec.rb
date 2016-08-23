require 'rails_helper'

RSpec.describe CommentsController, type: :controller do

  before(:all) do
    @user = User.create({username: "boleh-masuk", password: "12345", email: "boleh-masuk@email.com"})
    @user_admin = User.create({username: "boleh-masuk", password: "12345", email: "boleh-masuk@email.com", role: "admin"})
    @unauthorized_user = User.create({username: "no-entry", password: "54321", email: "no-entry@email.com"})
    @topic = Topic.create({title: "Example Title", description: "Example Description"})
    @post = Post.create({title: "Example Title", body: "Example Body"})
    @comment = Comment.create({body: "Example body", user_id: 1})
  end

  describe "index" do
    it "should render index" do

      params = { topic_id: @topic.slug, post_id: @post.slug }

      get :index, params: params

      expect(subject).to render_template(:index)
      expect(assigns[:comment]).to be_present
    end
  end

  describe "create" do

    it "should redirect if not logged in" do

      params = { topic_id: @topic.slug, post_id: @post.slug, comment: { body: "I'm a body" }}
      post :create, params: params

      expect(subject).to redirect_to(root_path)
      expect(flash[:danger]).to eql("You need to login first")
    end

    # it "should redirect if user unauthorized" do
    #
    #   params = { post_id: @topic.slug, post: { title: "I'm a title", body: "I'm a body" }}
    #   post :create, xhr: true, params: params, session: { id: @unauthorized_user.id }
    #
    #   expect(subject).to redirect_to(root_path)
    #   expect(flash[:danger]).to eql("You're not authorized")
    # end

    it "should create new comment" do

      params = { topic_id: @topic.slug, post_id: @post.slug, comment: { body: "I'm a body" }}
      post :create, xhr: true, params: params, session: { id: @user.id }

      comment = Comment.find_by(id: 2)

      expect(Comment.count).to eql(2)
      expect(comment.body).to eql("I'm a body")
      expect(flash[:success]).to eql("You've created a new comment.")
    end
  end

  describe "edit" do

    it "should redirect if not logged in" do

      params = { topic_id: @topic.slug, post_id: @post.slug, id: @comment.id }
      get :edit, params: params

      expect(subject).to redirect_to(root_path)
      expect(flash[:danger]).to eql("You need to login first")
    end

    it "should redirect if user unauthorized" do

      params = { topic_id: @topic.slug, post_id: @post.slug, id: @comment.id }
      get :edit, params: params, session: { id: @unauthorized_user.id }

      expect(subject).to redirect_to(root_path)
      expect(flash[:danger]).to eql("You're not authorized")
    end

    it "should render edit" do

      params = { topic_id: @topic.slug, post_id: @post.slug, id: @comment.id }
      get :edit, xhr: true, params: params, session: { id: @user.id }

      current_user = subject.send(:current_user)
      expect(subject).to render_template(:edit)
      expect(current_user).to be_present
    end
  end

  describe "update post" do

    it "should redirect if not logged in" do
      params = { topic_id: @topic.slug, post_id: @post.slug, id: @comment.id, comment: { body: "I'm a new body" } }
      patch :update, params: params

      expect(subject).to redirect_to(root_path)
      expect(flash[:danger]).to eql("You need to login first")
    end

    it "should redirect if user unauthorized" do
      params = { topic_id: @topic.slug, post_id: @post.slug, id: @comment.id, comment: { body: "I'm a new body" } }
      patch :update, xhr: true, params: params, session: { id: @unauthorized_user.id }

      expect(flash[:danger]).to eql("You're not authorized")
    end

    it "should update post" do

      params = { topic_id: @topic.slug, post_id: @post.slug, id: @comment.id, comment: { body: "I'm a new body" } }
      patch :update, xhr: true, params: params, session: { id: @user.id }

      @comment.reload

      expect(@comment.body).to eql("I'm a new body")
      expect(flash[:success]).to eql("You've edited the comment.")
    end
  end


end
