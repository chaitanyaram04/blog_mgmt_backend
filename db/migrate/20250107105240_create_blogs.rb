class CreateBlogs < ActiveRecord::Migration[7.1]
  def change
    create_table :blogs do |t|
      t.string :title
      t.text :description
      t.references :users, null: false, foreign_key: true

      t.timestamps
    end
  end
end
