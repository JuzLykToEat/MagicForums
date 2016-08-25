require 'rails_helper'

RSpec.describe TopicsController, type: :controller do

  before(:all) do
    # @user = User.create({username: "boleh-masuk", password: "12345", email: "boleh-masuk@email.com", role: "admin"})
    # @unauthorized_user = User.create({username: "no-entry", password: "54321", email: "no-entry@email.com"})
    # @topic = Topic.create({title: "Example Title", description: "Example Description", user_id: "1"})

    @user = create(:user, :admin)
    @unauthorized_user = create(:user)
    @topic = create(:topic)
  end

  describe "index" do
    it "should render index" do

      get :index

      expect(subject).to render_template(:index)
      expect(assigns[:topic]).to be_present
    end
  end

  describe "create" do

    it "should redirect if not logged in" do

      params = { topic: { title: "I'm a title", description: "I'm a description" }}
      post :create, params: params

      expect(subject).to redirect_to(root_path)
      expect(flash[:danger]).to eql("You need to login first")
    end

    it "should redirect if user unauthorized" do

      params = { topic: { title: "I'm a title", description: "I'm a description" }}
      post :create, params: params, session: { id: @unauthorized_user.id }

      expect(subject).to redirect_to(root_path)
      expect(flash[:danger]).to eql("You're not authorized")
    end

    it "should create new topic" do

      params = { topic: { title: "I'm a title", description: "I'm a description" }}
      post :create, xhr: true, params: params, session: { id: @user.id }

      topic = Topic.find_by(title: "I'm a title")

      expect(Topic.count).to eql(2)
      expect(topic.description).to eql("I'm a description")
      expect(flash[:success]).to eql("You've created a new topic.")
    end
  end

  describe "edit" do

    it "should redirect if not logged in" do

      params = { id: @topic.id }
      get :edit, params: params

      expect(subject).to redirect_to(root_path)
      expect(flash[:danger]).to eql("You need to login first")
    end

    it "should redirect if user unauthorized" do

      params = { id: @topic.id }
      get :edit, params: params, session: { id: @unauthorized_user.id }

      expect(subject).to redirect_to(root_path)
      expect(flash[:danger]).to eql("You're not authorized")
    end

    it "should render edit" do

      params = { id: @topic.id }
      get :edit, xhr: true, params: params, session: { id: @user.id }

      current_user = subject.send(:current_user)
      expect(subject).to render_template(:edit)
      expect(current_user).to be_present
    end
  end

  describe "update topic" do

    it "should redirect if not logged in" do
      params = { id: @topic.id, topic: { title: "I'm a new title", description: "I'm a new description" } }
      patch :update, params: params

      expect(subject).to redirect_to(root_path)
      expect(flash[:danger]).to eql("You need to login first")
    end

    it "should redirect if user unauthorized" do
      params = { id: @topic.id, topic: { title: "I'm a new title", description: "I'm a new description" } }
      patch :update, params: params, session: { id: @unauthorized_user.id }

      expect(subject).to redirect_to(root_path)
      expect(flash[:danger]).to eql("You're not authorized")
    end

    it "should update topic" do

      params = { id: @topic.id, topic: { title: "I'm a new title", description: "I'm a new description" } }
      patch :update, xhr: true, params: params, session: { id: @user.id }

      @topic.reload

      expect(@topic.title).to eql("I'm a new title")
      expect(@topic.description).to eql("I'm a new description")
      expect(flash[:success]).to eql("You've updated the topic.")
    end
  end


end
