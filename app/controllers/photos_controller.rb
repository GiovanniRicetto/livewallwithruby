# app/controllers/photos_controller.rb

class PhotosController < ApplicationController
  before_action :set_photo, only: %i[ show update destroy ]

  # GET /photos
  # UNIFICADO: Ação 'index' única e correta.
  def index
    @photos = Photo.all
    render json: @photos.map { |photo| photo_with_image_urls(photo) }
  end

  # GET /photos/1
  # CORRIGIDO: Ação 'show' agora usa o helper para múltiplas imagens.
  def show
    render json: photo_with_image_urls(@photo)
  end

  # POST /photos
  def create
    @photo = Photo.new(photo_params)

    if @photo.save
      # CORRIGIDO: Retorna o objeto com as URLs das imagens no sucesso.
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
    head :no_content # Adicionado para seguir a convenção RESTful
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
    return nil unless photo.persisted? # Garante que a foto foi salva
    photo.as_json.merge(image_urls: photo.images.map { |image| url_for(image) })
  end
end