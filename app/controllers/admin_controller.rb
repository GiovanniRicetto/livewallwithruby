# app/controllers/admin_controller.rb
class AdminController < ApplicationController
  def index
    photos = Photo.with_attached_images.order(created_at: :desc)
    videos = Video.with_attached_processed_gif.order(created_at: :desc)

    # Combina e ordena todas as mídias por data de criação para exibição no admin
    all_media = (photos + videos).sort_by(&:created_at).reverse

    # Formata os dados para serem facilmente consumidos pelo JavaScript
    render json: all_media.map { |media| format_media_for_admin(media) }
  end

  def destroy_photo
    photo = Photo.find(params[:id])
    photo.images.purge # Apaga os arquivos do disco
    photo.destroy      # Apaga o registro do banco de dados
    head :no_content
  end

  def destroy_video
    video = Video.find(params[:id])
    video.upload.purge
    video.processed_gif.purge
    video.destroy
    head :no_content
  end

  private

  def format_media_for_admin(media)
    if media.is_a?(Photo) && media.images.attached?
      # Para fotos, pega a primeira imagem como thumbnail
      { id: media.id, type: 'photo', url: url_for(media.images.first) }
    elsif media.is_a?(Video) && media.processed_gif.attached?
      # Para vídeos, usa o GIF processado como thumbnail
      { id: media.id, type: 'video', url: url_for(media.processed_gif) }
    end
  end
end