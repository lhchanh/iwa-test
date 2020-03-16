FactoryBot.define do
  factory :student do
    name { Faker::Name.name }
    email { Faker::Internet.email }
    password { '12345678' }
    type { 'Student' }
  end

  factory :teacher do
    name { Faker::Name.name }
    email { Faker::Internet.email }
    password { '12345678' }
    type { 'Teacher' }
  end
end