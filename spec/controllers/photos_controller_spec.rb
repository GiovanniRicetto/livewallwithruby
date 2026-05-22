require 'rails_helper'

RSpec.describe PhotosController, type: :controller do
  let(:valid_image) do
    fixture_file_upload(Rails.root.join('public', 'favicon.png'), 'image/png')
  end

  describe 'GET #index' do
    before do
      # Mock the URL generation for images in the controller
      allow_any_instance_of(PhotosController).to receive(:url_for).and_return('http://example.com/image.png')
    end

    it 'retorna todas as fotos se o parâmetro since não for enviado' do
      photo1 = Photo.create!(images: [valid_image])
      photo2 = Photo.create!(images: [valid_image])
      
      get :index
      
      expect(response).to have_http_status(:success)
      json = JSON.parse(response.body)
      expect(json.length).to eq(2)
    end

    it 'retorna apenas as fotos mais recentes usando o parâmetro since' do
      photo_antiga = Photo.create!(images: [valid_image])
      photo_antiga.update_columns(created_at: 2.days.ago)
      
      photo_nova = Photo.create!(images: [valid_image])

      get :index, params: { since: 1.day.ago.iso8601 }
      
      expect(response).to have_http_status(:success)
      json = JSON.parse(response.body)
      expect(json.length).to eq(1)
      expect(json.first['id']).to eq(photo_nova.id)
    end
  end

  describe 'POST #create' do
    before do
      allow_any_instance_of(PhotosController).to receive(:url_for).and_return('http://example.com/image.png')
    end

    it 'cria registros separados no banco de dados quando múltiplas fotos são enviadas' do
      expect {
        post :create, params: { photo: { images: [valid_image, valid_image] } }
      }.to change(Photo, :count).by(2)
      
      expect(response).to have_http_status(:created)
      json = JSON.parse(response.body)
      expect(json).to be_an(Array)
      expect(json.length).to eq(2)
    end

    it 'cria um único registro quando apenas uma foto é enviada' do
      expect {
        post :create, params: { photo: { images: [valid_image] } }
      }.to change(Photo, :count).by(1)
      
      expect(response).to have_http_status(:created)
      json = JSON.parse(response.body)
      expect(json).to be_an(Array)
      expect(json.length).to eq(1)
    end

    it 'retorna erro se enviar mais de 10 fotos sem flag admin_upload' do
      images = Array.new(11, valid_image)
      post :create, params: { photo: { images: images } }
      expect(response).to have_http_status(:unprocessable_entity)
      json = JSON.parse(response.body)
      expect(json['images']).to include("Não é possível enviar mais de 10 fotos de uma vez.")
    end

    it 'permite enviar até 50 fotos se admin_upload for verdadeiro' do
      images = Array.new(15, valid_image) # 15 > 10 (normal limit)
      expect {
        post :create, params: { photo: { images: images }, admin_upload: 'true' }
      }.to change(Photo, :count).by(15)
      expect(response).to have_http_status(:created)
    end
  end
end
