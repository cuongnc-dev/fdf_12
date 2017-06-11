FactoryGirl.define do
  factory :user do
    name {Faker::Name.name}
    password_confirmation "123456"
    avatar {Faker::Name.name}
    chatwork_id {Faker::Name.name}
    description {Faker::Hacker.say_something_smart}
    email {Faker::Internet.email}
    password "123456"
    status 1
    authentication_token {Devise.friendly_token}
  end
  trait :admin do
    role {User.roles[:admin]}
  end
end
