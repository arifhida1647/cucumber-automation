require 'httparty'
require 'json'
require 'rspec'

Given('I have valid change password user data') do
  # Dynamically construct the file path to 'env.rb'
  env_file_path = File.join(File.dirname(__FILE__), '..', '..', 'support', 'env.rb')

    # Load the env.rb file to get the ACCESS_TOKEN constant
  load(env_file_path)  # This will load the content of env.rb and make ACCESS_TOKEN available

    # Assign the ACCESS_TOKEN value to @access_token
  @access_token = ACCESS_TOKEN
  # Generate random email and password
  @random_string = (0...8).map { ('a'..'z').to_a[rand(26)] }.join
  @random_number = rand(1000..9999)
  
  @password = "Pass#{@random_number}"
  @base_url = 'https://api.staging.satudental.com/admin/users/' + $created_user_id.to_s + '/reset-password'
  @headers =   { "Authorization" => "Bearer #{@access_token}", 'Content-Type' => 'application/json' }
  @body = {
    new_password: @password
  }.to_json
end

When('I send a POST request to the endpoint change password user data') do
  response = HTTParty.post(@base_url, body: @body, headers: @headers)
  @response = response
end

Then('the response change password user status code should be {int}') do |expected_status_code|
  expect(@response.code).to eq(expected_status_code)
end




