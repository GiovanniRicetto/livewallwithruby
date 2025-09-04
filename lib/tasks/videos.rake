namespace :videos do
  desc "Reprocessa os vídeos que estão pendentes ou que falharam na conversão."
  task reprocess_failed: :environment do
    videos_to_reprocess = Video.where(status: ['pending', 'failed'])
    
    if videos_to_reprocess.any?
      puts "Encontrados #{videos_to_reprocess.count} vídeos para reprocessar."
      videos_to_reprocess.each do |video|
        puts "A colocar na fila o vídeo com ID: #{video.id}"
        VideoConversionJob.perform_later(video.id)
      end
      puts "Reprocessamento concluído."
    else
      puts "Nenhum vídeo pendente ou com falha encontrado."
    end
  end
end