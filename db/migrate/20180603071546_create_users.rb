class CreateUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :users do |t|

      t.string    :login, null: false
      t.integer   :level, null: false, default: 0

      t.string    :name

      t.string    :salt
      t.string    :password

      t.integer   :activated, null: false, default: 1

      t.timestamps
    end
  end
end
