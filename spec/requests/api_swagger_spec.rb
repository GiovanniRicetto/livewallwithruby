require 'swagger_helper'

RSpec.describe 'Live Wall API', type: :request do
  path '/photos' do
    get('List photos') do
      tags 'Photos'
      produces 'application/json'
      parameter name: :since, in: :query, type: :string, description: 'Filter photos created after this ISO8601 timestamp', required: false
      
      response(200, 'successful') do
        schema type: :array,
          items: {
            type: :object,
            properties: {
              id: { type: :integer },
              image_urls: { type: :array, items: { type: :string } },
              created_at: { type: :string, format: 'date-time' }
            }
          }
        run_test!
      end
    end

    post('Create photo(s)') do
      tags 'Photos'
      consumes 'multipart/form-data'
      parameter name: :admin_upload, in: :query, type: :boolean, description: 'Set to true to increase max images limit to 50', required: false
      parameter name: :photo, in: :formData, schema: {
        type: :object,
        properties: {
          'photo[images][]': { type: :array, items: { type: :file } },
          'photo[title]': { type: :string }
        },
        required: [ 'photo[images][]' ]
      }
      
      response(201, 'created') do
        let(:photo) { { title: 'Test', images: [Rack::Test::UploadedFile.new(Rails.root.join('public', 'favicon.png'), 'image/png')] } }
        run_test!
      end
      
      response(422, 'unprocessable entity') do
        let(:photo) { { title: 'Test', images: Array.new(11, Rack::Test::UploadedFile.new(Rails.root.join('public', 'favicon.png'), 'image/png')) } }
        run_test!
      end
    end
  end

  path '/photos/active_ids' do
    get('List active photo IDs') do
      tags 'Photos'
      produces 'application/json'
      
      response(200, 'successful') do
        schema type: :array, items: { type: :integer }
        run_test!
      end
    end
  end

  path '/photos/reset_all' do
    delete('Delete all photos') do
      tags 'Admin Actions'
      consumes 'application/json'
      parameter name: :payload, in: :body, schema: {
        type: :object,
        properties: {
          password: { type: :string, description: 'Master password' }
        },
        required: ['password']
      }
      
      response(204, 'No Content') do
        let(:payload) { { password: "Limpeza Total 3198" } }
        run_test!
      end
      
      response(401, 'Unauthorized') do
        let(:payload) { { password: "wrong" } }
        run_test!
      end
    end
  end

  path '/videos' do
    get('List videos') do
      tags 'Videos'
      produces 'application/json'
      parameter name: :since, in: :query, type: :string, description: 'Filter videos created after this ISO8601 timestamp', required: false
      
      response(200, 'successful') do
        schema type: :array,
          items: {
            type: :object,
            properties: {
              id: { type: :integer },
              gif_url: { type: :string, nullable: true },
              created_at: { type: :string, format: 'date-time' }
            }
          }
        run_test!
      end
    end

    post('Create a video') do
      tags 'Videos'
      consumes 'multipart/form-data'
      parameter name: :video, in: :formData, schema: {
        type: :object,
        properties: {
          'video[upload]': { type: :file }
        },
        required: [ 'video[upload]' ]
      }
      
      response(202, 'Accepted (Processing)') do
        let(:video) { { upload: Rack::Test::UploadedFile.new(Rails.root.join('public', 'favicon.png'), 'image/png') } }
        run_test!
      end
    end
  end

  path '/videos/active_ids' do
    get('List active video IDs') do
      tags 'Videos'
      produces 'application/json'
      
      response(200, 'successful') do
        schema type: :array, items: { type: :integer }
        run_test!
      end
    end
  end

  path '/videos/reset_all' do
    delete('Delete all videos') do
      tags 'Admin Actions'
      consumes 'application/json'
      parameter name: :payload, in: :body, schema: {
        type: :object,
        properties: {
          password: { type: :string, description: 'Master password' }
        },
        required: ['password']
      }
      
      response(204, 'No Content') do
        let(:payload) { { password: "Limpeza Total 3198" } }
        run_test!
      end
      
      response(401, 'Unauthorized') do
        let(:payload) { { password: "wrong" } }
        run_test!
      end
    end
  end
end
