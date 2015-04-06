class AddPictureToMeme < ActiveRecord::Migration
  def up
    add_attachment :memes, :picture
  end

  def down
    remove_attachment :memes, :picture
  end
end
