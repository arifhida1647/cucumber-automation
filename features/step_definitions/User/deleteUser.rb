require 'httparty'
require 'json'
require 'rspec'

Given('I have valid user delete data') do
 # Dynamically construct the file path to 'env.rb'
 env_file_path = File.join(File.dirname(__FILE__), '..', '..', 'support', 'env.rb')

 # Load the env.rb file to get the ACCESS_TOKEN constant
 load(env_file_path)  # This will load the content of env.rb and make ACCESS_TOKEN available

 # Assign the ACCESS_TOKEN value to @access_token
 @access_token = ACCESS_TOKEN
 @base_url = 'https://api.staging.satudental.com/admin/users/' + + $created_user_id.to_s
end

When('I send a DELETE request to the endpoint delete user data') do
  response = HTTParty.delete(@base_url, headers: { "Authorization" => "Bearer #{@access_token}" })
  @response = response
end

Then('the response delete user status code should be {int}') do |expected_status_code|
  expect(@response.code).to eq(expected_status_code)
end

