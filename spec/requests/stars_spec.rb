require 'spec_helper'

describe "stars#update" do
  let(:user) { FactoryGirl.create(:user) }
  let(:repo) { FactoryGirl.build(:repository) }

  before do
    login(user)
  end

  it "creates a new repository" do
    put '/star.json', repository: {name: repo.name}
    Repository.should have(1).record
  end

  it "associates the repository to the user" do
    put '/star.json', repository: {name: repo.name}
    user.repositories.should have(1).record
  end

  it "renders an updated JSON record" do
    put '/star.json', repository: {name: repo.name}
    json = json(response.body)

    json['stars'].should == 1
    json['hubstarred'].should be_true
  end
end
