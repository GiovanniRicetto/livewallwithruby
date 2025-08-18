# app/jobs/video_conversion_job.rb
class VideoConversionJob < ApplicationJob
  queue_as :default

  def perform(video_id)
    video = Video.find_by(id: video_id)
    return unless video

    # Define o estado como 'processing' no início
    video.update(status: 'processing')

    begin
      convert_video_to_gif(video)
      # Define como 'completed' se a conversão for bem-sucedida
      video.update(status: 'completed')
    rescue => e
      # Define como 'failed' em caso de erro
      video.update(status: 'failed')
      Rails.logger.error "Erro na conversão do vídeo para o Video ID #{video.id}: #{e.message}"
      Rails.logger.error e.backtrace.join("\n")
    end
  end

  private

  def convert_video_to_gif(video)
    temp_upload = Tempfile.new(["upload", video.upload.filename.extension_with_delimiter], binmode: true)
    temp_gif = Tempfile.new(["processed", ".gif"], binmode: true)
    
    begin
      video.upload.blob.download do |chunk|
        temp_upload.write(chunk)
      end
      temp_upload.rewind

      movie = FFMPEG::Movie.new(temp_upload.path)

      # --- ALTERAÇÃO PRINCIPAL AQUI ---
      # Usamos o filtro de vídeo (vf) para redimensionar, o que é mais confiável.
      # scale=640:-2: Redimensiona para 640px de largura e calcula a altura 
      # para manter a proporção. O -2 garante que a altura seja um número par,
      # evitando erros de codificação.
      transcoder_options = {
        custom: %w(-r 10 -f gif),
        video_filter: "scale=1024:-2" 
      }
      
      movie.transcode(temp_gif.path, transcoder_options)

      video.processed_gif.attach(
        io: File.open(temp_gif.path), 
        filename: "#{video.upload.filename.base}.gif", 
        content_type: 'image/gif'
      )

    ensure
      temp_upload.close
      temp_upload.unlink
      temp_gif.close
      temp_gif.unlink
    end
  end
end