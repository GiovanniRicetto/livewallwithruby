class Photo < ApplicationRecord

    has_many_attached :images
  
    validates :title, presence: false
    validates :images, presence: true
  
    validate :validate_image_count
  
    private
  
    def validate_image_count
      return if images.blank?
  
      if images.length > 2 # Aqui altera a quuantidade permitida de uploads simultaneos na página de upload
        errors.add(:images, "Não é possível enviar mais de 2 fotos de uma vez durante o evento.")
      end
    end
  end