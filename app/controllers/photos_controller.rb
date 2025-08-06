# app/controllers/photos_controller.rb

class PhotosController < ApplicationController
  before_action :set_photo, only: %i[ show update destroy ]

  # GET /photos
  def index
    @photos = Photo.all.order(created_at: :desc)
    render json: @photos.map { |photo| photo_with_image_urls(photo) }
  end

  # GET /photos/1
  def show
    render json: photo_with_image_urls(@photo)
  end

  # POST /photos
  def create
    @photo = Photo.new(photo_params)

    if @photo.save
      render json: photo_with_image_urls(@photo), status: :created, location: @photo
    else
      render json: @photo.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /photos/1
  def update
    if @photo.update(photo_params)
      render json: photo_with_image_urls(@photo)
    else
      render json: @photo.errors, status: :unprocessable_entity
    end
  end

  # DELETE /photos/1
  def destroy
    @photo.destroy!
    head :no_content
  end

  # --- AÇÕES ADICIONADAS ---

  # DELETE /photos/destroy_all
  def destroy_all
    Photo.destroy_all
    head :no_content
  end

  # DELETE /photos/reset_all
  def reset_all
    # Esta ação fará o mesmo que destroy_all para garantir a limpeza.
    Photo.destroy_all
    head :no_content
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_photo
    @photo = Photo.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def photo_params
    params.require(:photo).permit(:title, images: [])
  end

  # Helper para adicionar as URLs das imagens ao JSON de resposta.
  def photo_with_image_urls(photo)
    return nil unless photo.persisted?
    # Garante que o objeto retornado inclua o created_at para ordenação no frontend.
    photo.as_json.merge(
      image_urls: photo.images.map { |image| url_for(image) },
      created_at: photo.created_at
    )
  end
end