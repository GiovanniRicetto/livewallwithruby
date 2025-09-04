class AddStatusToVideos < ActiveRecord::Migration[8.0]
  def change
    add_column :videos, :status, :string, default: 'pending', null: false
    add_index :videos, :status
  end
end