require 'rails_helper'

RSpec.describe PasswordResetsController, type: :controller do

  before(:all) do

    @user = User.create({username: "Adam", password: "12345", email: "adam@email.com", id: 1, password_reset_token: nil, password_reset_at: nil})
    @token = "hahahahaha"
    @user_to_reset = User.create({username: "Boey", password: "12345", email: "boey@email.com", id: 2, password_reset_token: @token, password_reset_at: Time.now})

  end

  describe "new" do

    it "should reder new" do

      get :new

      expect(subject).to render_template(:new)

    end

  end

  describe "create" do

    it "should redirect back to form" do

      params = { reset: { email: "wrong@email.com"}}
      post :create, params: params

      @user.reload
      expect(@user.password_reset_token).to be_nil
      expect(@user.password_reset_at).to be_nil
      expect(flash[:danger]).to eql("User does not exist")
    end

    it "should send instruction to user" do

      params = { reset: { email: "adam@email.com"}}
      post :create, params: params
      @user.reload
      expect(@user.password_reset_token).to be_present
      expect(@user.password_reset_at).to be_present
      expect(ActionMailer::Base.deliveries.count).to eql(1)
      expect(flash[:success]).to eql("We've sent you instructions on how to reset your password")
    end
  end

  describe "edit" do

    it "should render edit" do

      params = { id: @token, reset: { email: "adam@email.com"}}
      get :edit, params: params

      expect(subject).to render_template(:edit)

    end
  end

  describe "update post" do

    it "should update post" do

      params = { id: @token, user: { password: "54321" }}
      patch :update, params: params

      @user_to_reset.reload
      @old_password_user = @user_to_reset.authenticate("12345")
      @updated_user = @user_to_reset.authenticate("54321")

      expect(@old_password_user).to eql(false)
      expect(@updated_user).to eql(@user_to_reset)
      expect(flash[:success]).to eql("Password updated, you may log in now")
    end
  end

end
