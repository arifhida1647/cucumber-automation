require 'httparty'
require 'json'
require 'rspec'


Given('I have valid user update data') do
  # Dynamically construct the file path to 'env.rb'
  env_file_path = File.join(File.dirname(__FILE__), '..', '..', 'support', 'env.rb')

    # Load the env.rb file to get the ACCESS_TOKEN constant
  load(env_file_path)  # This will load the content of env.rb and make ACCESS_TOKEN available

    # Assign the ACCESS_TOKEN value to @access_token
  @access_token = ACCESS_TOKEN
  # Generate random email and password
  random_string = (0...8).map { ('a'..'z').to_a[rand(26)] }.join
  @random_number = rand(1000..9999)
  @random_name = %w[John Alice Bob].sample
  
  @password = "Pass#{@random_number}"
  @base_url = 'https://api.staging.satudental.com/admin/users/' + $created_user_id.to_s
  @headers =   { "Authorization" => "Bearer #{@access_token}", 'Content-Type' => 'application/json' }
  @body = {
    name: "#{@random_name}_#{@random_number}",
    status: "ACTIVE",
    clinic_ids: [59],
    role_id: 1,
    password: @password
  }.to_json
end

When('I send a PUT request to the endpoint update the user data') do
  response = HTTParty.put(@base_url, body: @body, headers: @headers)
  @response = response
end

Then('the response update user status code should be {int}') do |expected_status_code|
  expect(@response.code).to eq(expected_status_code)
end




