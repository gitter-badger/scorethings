require 'google/api_client'

$google_api_client = Google::APIClient.new(
    application_name: 'scorethings',
    application_version: '0.1.0',
    authorization: nil,
    key:  ENV['GOOGLE_API_KEY'])
