require 'rails_helper'

RSpec.describe Photo, type: :model do
  describe 'validações' do
    it 'é inválido sem imagens anexadas' do
      photo = Photo.new(title: 'Sem imagem')
      expect(photo.valid?).to be_falsey
      # ActiveStorage records have a presence validation on the attachment
    end
  end
end
