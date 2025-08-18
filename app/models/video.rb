# app/models/video.rb
class Video < ApplicationRecord
    has_one_attached :upload
    has_one_attached :processed_gif
  
    validates :upload, presence: true
    validate :validate_video_duration
  
    private
  
    def validate_video_duration
      return unless upload.attached?
  
      # Esta validação deve ser feita no lado do cliente ou de forma mais robusta no servidor
      # Por enquanto, vamos assumir que o cliente validou a duração do vídeo
    end
  end