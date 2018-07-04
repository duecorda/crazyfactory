class CreateAsks < ActiveRecord::Migration[5.1]
  def change
    create_table :asks do |t|

      t.text  :content
      t.integer :question_id, null: false, default: 0
      t.integer :answered, null: false, default: 0

      t.timestamps
    end
  end
end
