require 'httparty'
require 'json'
require 'rspec'

Given('I have a valid Bearer token from ACCESS_TOKEN in env.rb for logout') do
 # Dynamically construct the file path to 'env.rb'
 env_file_path = File.join(File.dirname(__FILE__), '..', '..', 'support', 'env.rb')

 # Load the env.rb file to get the ACCESS_TOKEN constant
 load(env_file_path)  # This will load the content of env.rb and make ACCESS_TOKEN available

 # Assign the ACCESS_TOKEN value to @access_token
 @access_token = ACCESS_TOKEN
end

When('I send a POST request logout to {string}') do |url|
  response = HTTParty.post(url, headers: { "Authorization" => "Bearer #{@access_token}" })
  @response = response
end

Then('Success Logout and the response status code should be {int}') do |expected_status_code|
  expect(@response.code).to eq(expected_status_code)
end

Then('the response should indicate a successful logout message') do
  account_info = JSON.parse(@response.body)
  
  # Check if the response contains the 'message' and 'meta' keys
  expect(account_info).to have_key('message')
  expect(account_info['message']).to eq('Logout success')

  expect(account_info).to have_key('meta')
  expect(account_info['meta']).to have_key('http_code')
  expect(account_info['meta']['http_code']).to eq(200)
  env_file_path = File.join(File.dirname(__FILE__),'..','..', 'support', 'env.rb')
    File.open(env_file_path, 'w') do |file|
      file.puts "# Automatically generated by Logout"
      file.puts "ACCESS_TOKEN = ''"
    end
end