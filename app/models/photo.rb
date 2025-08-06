# app/models/photo.rb

class Photo < ApplicationRecord
    # Esta linha é a mais importante.
    # Ela cria os métodos '.images' e '.images=' que o erro diz que estão faltando.
    has_many_attached :images
  
    validates :title, presence: false
    validates :images, presence: true
  
    validate :validate_image_count
  
    private
  
    def validate_image_count
      return if images.blank?
  
      if images.length > 10
        errors.add(:images, "Não é possível enviar mais de 10 fotos de uma vez.")
      end
    end
  end