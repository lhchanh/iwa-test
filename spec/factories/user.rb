FactoryBot.define do
  factory :student do
    name { Faker::Name.name }
    email { Faker::Internet.email }
    password { '12345678' }
    type { 'Student' }
  end
end