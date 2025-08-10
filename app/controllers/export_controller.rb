# app/controllers/export_controller.rb
require 'zip'

class ExportController < ApplicationController
  def download_media
    # Define os caminhos para a pasta de exportação e para o arquivo zip final
    export_dir = Rails.root.join('tmp', 'arquivos_da_festa')
    zip_path = Rails.root.join('tmp', 'backup_festa.zip')

    # Garante que os arquivos antigos sejam removidos antes de uma nova exportação
    FileUtils.rm_rf(export_dir)
    FileUtils.rm_f(zip_path)
    FileUtils.mkdir_p(export_dir)

    # Carrega e executa a tarefa Rake 'export:media'
    Rails.application.load_tasks
    Rake::Task['export:media'].invoke

    # Cria o arquivo zip a partir da pasta de exportação
    Zip::File.open(zip_path, create: true) do |zipfile|
      # Itera sobre todos os arquivos na pasta de exportação
      Dir.glob("#{export_dir}/**/*").each do |file|
        # Adiciona cada arquivo ao zip, mantendo a estrutura de pastas
        zipfile.add(File.basename(file), file)
      end
    end

    # Envia o arquivo zip para o navegador do utilizador para download
    send_file zip_path,
              type: 'application/zip',
              disposition: 'attachment',
              filename: "backup_festa_#{Time.now.strftime('%Y-%m-%d')}.zip"
  end
end