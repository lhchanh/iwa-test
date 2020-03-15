class SubmitAnswer
  prepend SimpleCommand

  def initialize(user_id:, test_id:, question_id: , option_ids:)
    @user_id = user_id
    @test_id = test_id
    @question_id = question_id
    @option_ids = option_ids
  end

  def call
    check_answer
  end

  private

  def check_answer
    true
  end

  attr_accessor :user_id, :test_id, :question_id, :option_ids
end
