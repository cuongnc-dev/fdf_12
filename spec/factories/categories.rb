FactoryGirl.define do
  factory :category do
    name {Faker::Name.name}
    created_at {Faker::Time.forward(27)}
    updated_at {Faker::Time.forward(28)}
  end
end
