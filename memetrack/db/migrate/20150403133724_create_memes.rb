class CreateMemes < ActiveRecord::Migration
  def change
    create_table :memes do |t|
      t.text :tags, array: true
      t.timestamps null: false
    end
    add_index :memes, :tags, using: 'gin'
  end
end
