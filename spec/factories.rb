FactoryGirl.define do
  factory :user do
    sequence(:username) { |n| "User#{n}" }
    github_access_token 'acccesstoken'
  end

  factory :repository do
    sequence(:name) { |n| "user/repo#{n}" }
  end
end
