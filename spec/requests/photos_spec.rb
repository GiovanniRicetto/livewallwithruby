require 'rails_helper'

RSpec.describe "Photos API Contract", type: :request do
  let(:valid_image) { fixture_file_upload(Rails.root.join('public', 'favicon.png'), 'image/png') }

  describe "GET /photos" do
    it "returns the correct JSON contract for photos" do
      Photo.create!(images: [valid_image])
      
      get photos_path
      
      expect(response).to have_http_status(:ok)
      
      json_response = JSON.parse(response.body)
      expect(json_response).to be_an(Array)
      
      if json_response.any?
        first_photo = json_response.first
        expect(first_photo).to have_key('id')
        expect(first_photo).to have_key('image_urls')
        expect(first_photo['image_urls']).to be_an(Array)
        expect(first_photo).to have_key('created_at')
      end
    end
  end

  describe "POST /photos" do
    it "returns the correct JSON contract for created photos" do
      post photos_path, params: { photo: { images: [valid_image] } }
      
      expect(response).to have_http_status(:created)
      
      json_response = JSON.parse(response.body)
      expect(json_response).to be_an(Array)
      
      first_photo = json_response.first
      expect(first_photo).to have_key('id')
      expect(first_photo).to have_key('image_urls')
      expect(first_photo).to have_key('created_at')
    end
    
    it "returns the correct JSON contract for validation errors" do
      post photos_path, params: { photo: { images: Array.new(11, valid_image) } }
      
      expect(response).to have_http_status(:unprocessable_entity)
      json_response = JSON.parse(response.body)
      
      expect(json_response).to have_key('images')
      expect(json_response['images']).to be_an(Array)
      expect(json_response['images'].first).to be_a(String)
    end
  end

  describe "GET /photos/active_ids" do
    it "returns an array of integers" do
      Photo.create!(images: [valid_image])
      
      get active_ids_photos_path
      
      expect(response).to have_http_status(:ok)
      json_response = JSON.parse(response.body)
      expect(json_response).to be_an(Array)
      expect(json_response.first).to be_an(Integer) if json_response.any?
    end
  end
end
