# app/controllers/videos_controller.rb
class VideosController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:create], raise: false

  def index
    # --- ALTERAÇÃO PRINCIPAL AQUI ---
    # `with_attached_processed_gif` pré-carrega os GIFs processados.
    @videos = Video.with_attached_processed_gif.order(created_at: :desc)
    render json: @videos.map { |video| video_with_gif_url(video) }
  end
  
  # ... (o resto do controller permanece o mesmo)
  def create
    @video = Video.new(video_params)

    if @video.save
      VideoConversionJob.perform_later(@video.id)
      render json: { message: 'O vídeo está sendo processado.' }, status: :accepted
    else
      render json: @video.errors, status: :unprocessable_entity
    end
  end

  def reset_all
    Video.destroy_all
    head :no_content
  end

  private

  def video_params
    params.require(:video).permit(:upload)
  end

  def video_with_gif_url(video)
    return nil unless video.persisted?
    video.as_json.merge(
      gif_url: video.processed_gif.attached? ? url_for(video.processed_gif) : nil,
      created_at: video.created_at
    )
  end
end