json.extract! @analisy_type, :id, :title, :nuclides, :created_at, :updated_at
json.url analisy_type_url(analisy_type, format: :json)