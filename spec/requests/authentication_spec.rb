require 'spec_helper'

describe "Authentication" do
  context "on successful sign in" do
    before do
      mock_auth("newuser")
    end

    it "should create a new User record" do
      get "/auth/github"
      follow_redirect!
      User.should have(1).record
      User.last.username.should == 'newuser'
    end

    context "when user record already exists" do
      it "should use the existing record" do
        user = FactoryGirl.create(:user)
        mock_auth(user.username)

        get "/auth/github"
        follow_redirect!
        User.should have(1).record
        User.last.username.should == user.username
      end
    end
  end

  context "on unsuccessful sign in" do
    it "does something" do
      OmniAuth.config.mock_auth[:github] = :invalid_credentials

      get "/auth/github"
      follow_redirect!
      response.should redirect_to('/auth/failure?message=invalid_credentials')
    end
  end
end
