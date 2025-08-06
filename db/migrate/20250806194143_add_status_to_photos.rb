class AddStatusToPhotos < ActiveRecord::Migration[8.0]
  def change
    add_column :photos, :status, :string
  end
end
