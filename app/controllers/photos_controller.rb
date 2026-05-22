# app/controllers/photos_controller.rb

class PhotosController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:create, :reset_all], raise: false
  before_action :set_photo, only: %i[ show update destroy ]

  def index
    @photos = Photo.with_attached_images.order(created_at: :desc)
    
    if params[:since].present?
      @photos = @photos.where('created_at > ?', Time.zone.parse(params[:since]))
    end

    render json: @photos.map { |photo| photo_with_image_urls(photo) }
  end

  def create
    images = photo_params[:images] || []
    images = [images] unless images.is_a?(Array)

    max_photos = params[:admin_upload] == 'true' ? 50 : 10
    if images.length > max_photos
      render json: { images: ["Não é possível enviar mais de #{max_photos} fotos de uma vez."] }, status: :unprocessable_entity
      return
    end

    created_photos = []
    errors = []

    Photo.transaction do
      images.each do |image|
        photo = Photo.new(title: photo_params[:title], images: [image])
        
        if params[:admin_upload] == 'true'
          if photo.save(validate: false)
            created_photos << photo
          else
            errors << photo.errors
            raise ActiveRecord::Rollback
          end
        else
          if photo.save
            created_photos << photo
          else
            errors << photo.errors
            raise ActiveRecord::Rollback
          end
        end
      end
    end

    if errors.empty?
      render json: created_photos.map { |p| photo_with_image_urls(p) }, status: :created
    else
      render json: errors.first, status: :unprocessable_entity
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
    if params[:password] != "Limpeza Total 3198"
      render json: { error: 'Senha incorreta' }, status: :unauthorized
      return
    end
    Photo.destroy_all
    head :no_content
  end

  def active_ids
    render json: Photo.pluck(:id)
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