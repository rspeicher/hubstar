require 'spec_helper'

describe Repository do
  subject { FactoryGirl.create(:repository) }
  let(:user) { FactoryGirl.create(:user) }

  it { should validate_uniqueness_of(:name) }
  it { should allow_value("tsigo/hubstar").for(:name) }
  it { should allow_value("tsigo/hubstar.dev").for(:name) }
  it { should_not allow_value("tsigo").for(:name) }
  it { should_not allow_value("github.com/tsigo/hubstar").for(:name) }

  it { should allow_mass_assignment_of(:name) }
  it { should allow_mass_assignment_of(:description) }
  it { should allow_mass_assignment_of(:watchers) }
  it { should allow_mass_assignment_of(:forks) }
  it { should allow_mass_assignment_of(:user) }

  it { should have_and_belong_to_many(:users) }

  describe "#has_user?" do
    it "returns false when user is nil" do
      subject.has_user?(nil).should be_false
    end

    it "returns false when user does not have this repository" do
      subject.has_user?(user).should be_false
    end

    it "returns true when user has this repository" do
      subject.users << user
      subject.has_user?(user).should be_true
    end
  end

  describe "#users_with_priority_to" do
    it "shifts the current user to the front of the line" do
      subject.users << FactoryGirl.create(:user)
      subject.users << user

      subject.users[0].should_not == user
      subject.users_with_priority_to(user)[0].should == user
    end
  end

  describe "mass-assigning a user" do
    it "adds an associated user" do
      subject.update_attributes(user: user)
      User.last.repositories.should have(1).record
    end

    it "does not add an existing user" do
      subject.users << user

      subject.update_attributes(user: user)
      User.last.repositories.should have(1).record
    end
  end
end
