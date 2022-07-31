FactoryBot.define do
  factory :user do
    name { 'test_user' }
    sequence(:email) { |n| "tester#{n}@example.com" }
    password { 'password' }
    password_digest { 'password' }
    point { User::REGISTRATION_REWARD_POINT }
    token { 'test_token' }
  end
end
