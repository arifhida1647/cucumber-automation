require 'httparty'
require 'json'
require 'rspec'

Given('I have a valid Bearer token from ACCESS_TOKEN in env.rb for get info by me') do
 # Dynamically construct the file path to 'env.rb'
 env_file_path = File.join(File.dirname(__FILE__), '..', '..', 'support', 'env.rb')

 # Load the env.rb file to get the ACCESS_TOKEN constant
 load(env_file_path)  # This will load the content of env.rb and make ACCESS_TOKEN available

 # Assign the ACCESS_TOKEN value to @access_token
 @access_token = ACCESS_TOKEN
end

When('I send a GET request to {string}') do |url|
  response = HTTParty.get(url, headers: { "Authorization" => "Bearer #{@access_token}" })
  @response = response
end

Then('Success GET info by me and the response status code should be {int}') do |expected_status_code|
  expect(@response.code).to eq(expected_status_code)
end

Then('the response should contain my account information') do
  account_info = JSON.parse(@response.body)
  
   expect(account_info).to have_key('data')
   expect(account_info['data']).to have_key('id')
end
