# db/migrate/YYYYMMDDHHMMSS_create_videos.rb
class CreateVideos < ActiveRecord::Migration[8.0]
  def change
    create_table :videos do |t|
      t.timestamps
    end
  end
end