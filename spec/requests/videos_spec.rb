require 'rails_helper'

RSpec.describe "Videos API Contract", type: :request do
  describe "GET /videos" do
    it "returns the correct JSON contract for videos" do
      get videos_path
      
      expect(response).to have_http_status(:ok)
      json_response = JSON.parse(response.body)
      expect(json_response).to be_an(Array)
    end
  end

  describe "POST /videos" do
    it "returns the correct JSON contract for created videos" do
      ActiveJob::Base.queue_adapter = :test
      
      post videos_path, params: { video: { upload: fixture_file_upload(Rails.root.join('public', 'favicon.png'), 'image/png') } }
      
      expect(response).to have_http_status(:accepted)
      
      json_response = JSON.parse(response.body)
      expect(json_response).to have_key('message')
      expect(json_response['message']).to be_a(String)
    end
  end

  describe "GET /videos/active_ids" do
    it "returns an array of integers" do
      get active_ids_videos_path
      
      expect(response).to have_http_status(:ok)
      json_response = JSON.parse(response.body)
      expect(json_response).to be_an(Array)
    end
  end
end
