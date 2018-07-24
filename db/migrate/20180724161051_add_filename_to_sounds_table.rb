class AddFilenameToSoundsTable < ActiveRecord::Migration[5.2]
  def change
    add_column :sounds, :filename, :text
  end
end
