FactoryGirl.define do
  factory :domain do
    name {Faker::Name.name}
    status 1
    owner 1
  end
end
