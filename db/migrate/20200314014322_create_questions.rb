class CreateQuestions < ActiveRecord::Migration[6.0]
  def change
    create_table :questions do |t|
      t.integer :test_id
      t.string :label
      t.string :description
    end
  end
end
