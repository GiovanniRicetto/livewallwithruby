class Video < ApplicationRecord
    has_one_attached :upload
    has_one_attached :processed_gif
  
    validates :upload, presence: true
    validate :validate_video_duration
  
    private
  
    def validate_video_duration
      return unless upload.attached?
    end
  end