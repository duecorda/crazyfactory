class CreatePhotos < ActiveRecord::Migration[5.1]
  def change
    create_table :photos do |t|
      t.integer   :article_id

      t.string    :hashkey

      t.string    :original_filename
      t.string    :filename
      t.string    :content_type
      t.string    :filesize
      t.string    :dimensions
      t.string    :positions
      t.string    :details

      t.string    :title
      t.text      :content
      t.text      :colors

      t.timestamps null: false

      t.timestamps
    end
  end
end
