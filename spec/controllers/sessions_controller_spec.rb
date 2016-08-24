require 'rails_helper'

RSpec.describe SessionsController, type: :controller do

  before(:all) do
    @user = User.create({username: "Adam", password: "12345", email: "adam@email.com", id: 1})
  end

  describe "new" do

    it "should reder new" do

      get :new

      expect(subject).to render_template(:new)

    end

  end

  describe "create" do

    it "should redirect back to log in" do

      params = { user: { email: "adam@email.com", password: "wrong_password" }}
      post :create, params: params

      expect(flash[:danger]).to eql("Error logging in")
    end

    it "should log in user" do

      params = { user: { email: "adam@email.com", password: "12345" }}
      post :create, params: params

      expect(session[:id]).to eql(@user.id)
      current_user = subject.send(:current_user)
      expect(flash[:success]).to eql("Welcome back #{current_user.username}")
    end
  end

  describe "destroy" do

    it "should redirect when logged out" do

      params = { id: @user.id }
      delete :destroy, params: params, session: { id: @user.id }

      expect(subject).to redirect_to(root_path)
      expect(flash[:success]).to eql("You've been logged out")
    end
  end

end
