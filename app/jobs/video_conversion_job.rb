# app/jobs/video_conversion_job.rb
class VideoConversionJob < ApplicationJob
  queue_as :default

  def perform(photo_id)
    photo = Photo.find_by(id: photo_id)
    return unless photo&.upload&.attached?

    # Não precisa mais chamar photo.processing!, o controller já fez isso.
    
    begin
      # Converte o vídeo para GIF
      convert_video_to_gif(photo)
      photo.completed! if photo.processed_gif.attached?
    rescue => e
      photo.failed!
      Rails.logger.error "Erro na conversão do vídeo para a Photo ID #{photo.id}: #{e.message}"
    end
  end

  private

  def convert_video_to_gif(photo)
    temp_upload = Tempfile.new(["upload", photo.upload.filename.extension_with_delimiter])
    temp_gif = Tempfile.new(["processed", ".gif"])
    begin
      photo.upload.blob.download { |chunk| temp_upload.write(chunk) }
      temp_upload.rewind
      movie = FFMPEG::Movie.new(temp_upload.path)
      movie.transcode(temp_gif.path, { custom: %w(-r 10 -s 640x-1) })
      photo.processed_gif.attach(io: temp_gif, filename: "#{photo.upload.filename.base}.gif", content_type: 'image/gif')
    ensure
      temp_upload.close
      temp_upload.unlink
      temp_gif.close
      temp_gif.unlink
    end
  end
end