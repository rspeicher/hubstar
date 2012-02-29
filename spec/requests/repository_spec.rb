require 'spec_helper'

describe "repositories#index" do
  let(:user) { FactoryGirl.create(:user) }
  let(:repo) { FactoryGirl.create(:repository) }

  context "when logged in" do
    it "returns an array of starred repositories" do
      login(user)
      repo.users << user

      get "/repositories.json"
      response.body.should == %{["#{repo.to_s}"]}
    end
  end

  context "when not logged in" do
    it "returns an error" do
      get "/repositories.json"
      json = json(response.body)
      json['error'].should_not be_nil
    end
  end
end

describe "repositories#show" do
  let(:user) { FactoryGirl.create(:user) }
  let(:repo) { FactoryGirl.create(:repository) }

  context "when logged in" do
    before do
      login(user)
    end

    it "correctly defines `hubstarred`" do
      repo.users << user

      get "/repositories/#{repo.to_s}", :format => 'json'
      json = json(response.body)

      json['stars'].should == 1
      json['hubstarred'].should be_true
    end
  end

  context "when not logged in" do
    it "correctly defines `hubstarred`" do
      get "/repositories/#{repo.to_s}", :format => 'json'

      json = json(response.body)

      json['stars'].should == 0
      json['hubstarred'].should be_false
    end
  end
end
