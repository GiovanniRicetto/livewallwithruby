class Photo < ApplicationRecord

    has_many_attached :images
  
    validates :title, presence: false
    validates :images, presence: true
  end