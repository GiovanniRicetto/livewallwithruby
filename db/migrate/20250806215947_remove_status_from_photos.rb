class RemoveStatusFromPhotos < ActiveRecord::Migration[7.1]
  def change
    remove_column :photos, :status, :string
  end
end