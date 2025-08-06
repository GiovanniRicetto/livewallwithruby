# app/controllers/videos_controller.rb
class VideosController < ApplicationController
  def create
    @video = Video.new(video_params)

    if @video.save
      VideoConversionJob.perform_later(@video.id)
      render json: { message: 'O vídeo está sendo processado.' }, status: :accepted
    else
      render json: @video.errors, status: :unprocessable_entity
    end
  end

  def index
    @videos = Video.all.order(created_at: :desc)
    render json: @videos.map { |video| video_with_gif_url(video) }
  end

  # --- AÇÃO ADICIONADA ---
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
    # Garante que o objeto retornado inclua o created_at e a gif_url.
    video.as_json.merge(
      gif_url: video.processed_gif.attached? ? url_for(video.processed_gif) : nil,
      created_at: video.created_at
    )
  end
end