# app/controllers/export_controller.rb
require 'zip'

class ExportController < ApplicationController
  def download_media
    export_dir = Rails.root.join('tmp', 'arquivos_da_festa')
    zip_path = Rails.root.join('tmp', 'backup_festa.zip')

    FileUtils.rm_rf(export_dir)
    FileUtils.rm_f(zip_path)
    FileUtils.mkdir_p(export_dir)

    # Garante que o Rake pode carregar as tarefas
    Rails.application.load_tasks
    
    # --- ALTERAÇÃO PRINCIPAL AQUI ---
    # Reativa a tarefa para que ela possa ser executada novamente
    Rake::Task['export:media'].reenable
    
    # Executa a tarefa
    Rake::Task['export:media'].invoke

    # Cria o arquivo zip
    Zip::File.open(zip_path, create: true) do |zipfile|
      Dir.glob("#{export_dir}/**/*").each do |file|
        zipfile.add(File.basename(file), file)
      end
    end

    # Envia o arquivo para download
    send_file zip_path,
              type: 'application/zip',
              disposition: 'attachment',
              filename: "backup_festa_#{Time.now.strftime('%Y-%m-%d')}.zip"
  end
end