require 'rails_helper'

RSpec.describe PostsController, type: :controller do

  before(:all) do
    # @user = User.create({username: "boleh-masuk", password: "12345", email: "boleh-masuk@email.com"})
    # @user_admin = User.create({username: "boleh-masuk", password: "12345", email: "boleh-masuk@email.com", role: "admin"})
    # @unauthorized_user = User.create({username: "no-entry", password: "54321", email: "no-entry@email.com"})
    # @topic = Topic.create({title: "Example Title", description: "Example Description"})
    # @post = Post.create({title: "Example Title", body: "Example Body", user_id: 1})

    @user_admin = create(:user, :admin)
    @user = create(:user, :sequenced_email, :sequenced_username)
    @unauthorized_user = create(:user, :sequenced_email, :sequenced_username)
    @topic = create(:topic)
    @post = create(:post, user_id: 2)
  end

  describe "index" do
    it "should render index" do

      params = { topic_id: @topic.slug }

      get :index, params: params

      expect(subject).to render_template(:index)
      expect(assigns[:post]).to be_present
    end
  end

  describe "create" do

    it "should redirect if not logged in" do

      params = { topic_id: @topic.slug, post: { title: "I'm a title", body: "I'm a body" }}
      post :create, params: params

      expect(subject).to redirect_to(root_path)
      expect(flash[:danger]).to eql("You need to login first")
    end

    # it "should redirect if user unauthorized" do
    #
    #   params = { topic_id: @topic.slug, post: { title: "I'm a title", body: "I'm a body" }}
    #   post :create, xhr: true, params: params, session: { id: @unauthorized_user.id }
    #
    #   expect(subject).to redirect_to(root_path)
    #   expect(flash[:danger]).to eql("You're not authorized")
    # end

    it "should create new topic" do

      params = { topic_id: @topic.slug, post: { title: "I'm a title", body: "I'm a body" }}
      post :create, xhr: true, params: params, session: { id: @user.id }

      post = Post.find_by(title: "I'm a title")

      expect(Post.count).to eql(2)
      expect(post.body).to eql("I'm a body")
      expect(flash[:success]).to eql("You've created a new post.")
    end
  end

  describe "edit" do

    it "should redirect if not logged in" do

      params = { topic_id: @topic.slug, id: @post.id }
      get :edit, params: params

      expect(subject).to redirect_to(root_path)
      expect(flash[:danger]).to eql("You need to login first")
    end

    it "should redirect if user unauthorized" do

      params = { topic_id: @topic.slug, id: @post.id }
      get :edit, params: params, session: { id: @unauthorized_user.id }

      expect(subject).to redirect_to(root_path)
      expect(flash[:danger]).to eql("You're not authorized")
    end

    it "should render edit" do

      params = { topic_id: @topic.slug, id: @post.id }
      get :edit, xhr: true, params: params, session: { id: @user.id }
      current_user = subject.send(:current_user)
      expect(subject).to render_template(:edit)
      expect(current_user).to be_present
    end

    # it "should render edit with admin" do
    #
    #   params = { topic_id: @topic.slug, id: @post.id }
    #   get :edit, xhr: true, params: params, session: { id: @user_admin.id }
    #
    #   current_user = subject.send(:current_user)
    #   expect(subject).to render_template(:edit)
    #   expect(current_user).to be_present
    # end
  end

  describe "update post" do

    it "should redirect if not logged in" do
      params = { topic_id: @topic.slug, id: @post.id, post: { title: "I'm a new title", body: "I'm a new body" } }
      patch :update, params: params

      expect(subject).to redirect_to(root_path)
      expect(flash[:danger]).to eql("You need to login first")
    end

    it "should redirect if user unauthorized" do
      params = { topic_id: @topic.slug, id: @post.id, post: { title: "I'm a new title", body: "I'm a new body" } }
      patch :update, xhr: true, params: params, session: { id: @unauthorized_user.id }

      expect(flash[:danger]).to eql("You're not authorized")
    end

    it "should update post" do

      params = { topic_id: @topic.slug, id: @post.id, post: { title: "I'm a new title", body: "I'm a new body" } }
      patch :update, xhr: true, params: params, session: { id: @user.id }

      @post.reload

      expect(@post.title).to eql("I'm a new title")
      expect(@post.body).to eql("I'm a new body")
      expect(flash[:success]).to eql("You've edited the post.")
    end
  end


end
