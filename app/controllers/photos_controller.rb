# app/controllers/photos_controller.rb

class PhotosController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:create], raise: false
  before_action :set_photo, only: %i[ show update destroy ]

  def index
    # --- ALTERAÇÃO PRINCIPAL AQUI ---
    # Usamos `with_attached_images` para pré-carregar todas as imagens
    # numa única consulta, resolvendo o problema de N+1.
    @photos = Photo.with_attached_images.order(created_at: :desc)
    
    render json: @photos.map { |photo| photo_with_image_urls(photo) }
  end

  # ... (o resto do controller, como 'create', 'show', etc., permanece o mesmo)
  def create
    @photo = Photo.new(photo_params)

    if params[:admin_upload] == 'true'
      if @photo.save(validate: false)
        render json: photo_with_image_urls(@photo), status: :created, location: @photo
      else
        render json: @photo.errors, status: :unprocessable_entity
      end
    else
      if @photo.save
        render json: photo_with_image_urls(@photo), status: :created, location: @photo
      else
        render json: @photo.errors, status: :unprocessable_entity
      end
    end
  end
  
  def show
    render json: photo_with_image_urls(@photo)
  end

  def update
    if @photo.update(photo_params)
      render json: photo_with_image_urls(@photo)
    else
      render json: @photo.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @photo.destroy!
    head :no_content
  end

  def destroy_all
    Photo.destroy_all
    head :no_content
  end

  def reset_all
    Photo.destroy_all
    head :no_content
  end

  private

  def set_photo
    @photo = Photo.find(params[:id])
  end

  def photo_params
    params.require(:photo).permit(:title, images: [])
  end

  def photo_with_image_urls(photo)
    return nil unless photo.persisted?
    photo.as_json.merge(
      image_urls: photo.images.map { |image| url_for(image) },
      created_at: photo.created_at
    )
  end
end