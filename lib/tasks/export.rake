# lib/tasks/export.rake

namespace :export do
    desc "Exporta todas as fotos e GIFs processados para uma pasta local com os seus nomes originais."
    task media: :environment do
      # Define a pasta de destino para os arquivos exportados
      export_path = Rails.root.join('tmp', 'arquivos_da_festa')
      FileUtils.mkdir_p(export_path)
  
      puts "Iniciando a exportação para a pasta: #{export_path}"
  
      # Exporta as Fotos
      puts "Exportando fotos..."
      Photo.find_each do |photo|
        photo.images.each do |image|
          # Define o nome e o caminho do novo arquivo
          new_filepath = export_path.join(image.filename.to_s)
          
          # Copia o arquivo do storage para o destino, renomeando-o
          File.open(new_filepath, 'wb') do |file|
            image.download { |chunk| file.write(chunk) }
          end
          puts " -> Foto exportada: #{image.filename}"
        end
      end
      puts "Fotos exportadas com sucesso!"
  
      # Exporta os GIFs dos Vídeos
      puts "\nExportando GIFs..."
      Video.find_each do |video|
        if video.processed_gif.attached?
          gif = video.processed_gif
          # Define um nome único para cada GIF, ex: video_1.gif
          new_filename = "video_#{video.id}.gif"
          new_filepath = export_path.join(new_filename)
  
          # Copia o GIF do storage para o destino
          File.open(new_filepath, 'wb') do |file|
            gif.download { |chunk| file.write(chunk) }
          end
          puts " -> GIF exportado: #{new_filename}"
        end
      end
      puts "GIFs exportados com sucesso!"
  
      puts "\nExportação concluída! Verifique a pasta #{export_path}"
    end
  end