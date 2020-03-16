FactoryBot.define do
  factory :option do
    answer { 'This is an answer of the question' }
    correct { true }
    question
  end
end