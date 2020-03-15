class CreateOptions < ActiveRecord::Migration[6.0]
  def change
    create_table :options do |t|
      t.integer :question_id
      t.string :answer
      t.boolean :correct , default: false
    end
  end
end
