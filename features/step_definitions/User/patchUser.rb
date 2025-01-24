require 'httparty'
require 'json'
require 'rspec'

Given('I have valid user status data') do
  # Dynamically construct the file path to 'env.rb'
  env_file_path = File.join(File.dirname(__FILE__), '..', '..', 'support', 'env.rb')

    # Load the env.rb file to get the ACCESS_TOKEN constant
  load(env_file_path)  # This will load the content of env.rb and make ACCESS_TOKEN available

    # Assign the ACCESS_TOKEN value to @access_token
  @access_token = ACCESS_TOKEN
  @random_status = %w[INACTIVE ACTIVE].sample  
  @base_url = 'https://api.staging.satudental.com/admin/users/' + + $created_user_id.to_s + '/status'
  @headers =   { "Authorization" => "Bearer #{@access_token}", 'Content-Type' => 'application/json' }
  @body = {
    status: @random_status
  }.to_json
end

When('I send a PATCH request to the endpoint update status user data') do
  response = HTTParty.patch(@base_url, body: @body, headers: @headers)
  @response = response
  puts response.body
end

Then('the response update status user status code should be {int}') do |expected_status_code|
  expect(@response.code).to eq(expected_status_code)
end




