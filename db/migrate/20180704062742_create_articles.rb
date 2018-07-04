class CreateArticles < ActiveRecord::Migration[5.1]
  def change
    create_table :articles do |t|

      t.string  :tab
      t.string  :category

      t.string  :title
      t.string  :normal_price
      t.string  :price

      t.text    :content


      t.timestamps
    end
  end
end
