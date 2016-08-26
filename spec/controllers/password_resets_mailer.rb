require 'rails_helper'

describe PasswordResetsMailer do
  before(:all) do
    # @user = User.create({username: "Adam", password: "12345", email: "adam@email.com", id: 1, password_reset_token: nil, password_reset_at: nil})
    @user = create(:user)
  end

  describe "should send email" do
    it "should send email with link to reset password" do

      @user.update(password_reset_token: "resettoken", password_reset_at: DateTime.now)
      mail = PasswordResetsMailer.password_reset_mail(@user)

      expect(mail.to[0]).to eql(@user.email)
      expect(mail.body.include?("#{ENV.fetch('SERVER_URL')}/password_resets/resettoken/edit")).to eql(true)
    end
  end
end