require 'httparty'
require 'json'
require 'rspec'
# Variabel global untuk menyimpan ID pengguna yang dibuat
$created_user_id = nil

Given('I have valid user data') do
  # Dynamically construct the file path to 'env.rb'
  env_file_path = File.join(File.dirname(__FILE__), '..', '..', 'support', 'env.rb')

    # Load the env.rb file to get the ACCESS_TOKEN constant
  load(env_file_path)  # This will load the content of env.rb and make ACCESS_TOKEN available

    # Assign the ACCESS_TOKEN value to @access_token
  @access_token = ACCESS_TOKEN
  # Generate random email and password
  random_string = (0...8).map { ('a'..'z').to_a[rand(26)] }.join
  @random_number = rand(1000..9999)
  @random_domain = %w[gmail.com yahoo.com example.com].sample
  @random_name = %w[John Alice Bob].sample
  
  @password = "Pass#{@random_number}"
  @base_url = 'https://api.staging.satudental.com/admin/users'
  @headers =   { "Authorization" => "Bearer #{@access_token}", 'Content-Type' => 'application/json' }
  @body = {
    email: "#{random_string}#{@random_number}@#{@random_domain}",
    name: "#{@random_name}_#{@random_number}",
    clinic_ids: [59],
    role_id: 1,
    password: @password
  }.to_json
end

When('I send a POST request to the endpoint create the user data') do
  response = HTTParty.post(@base_url, body: @body, headers: @headers)
  @response = response

  # Parse the response JSON and extract the user ID
  response_data = JSON.parse(response.body)
  if response_data['data'] && response_data['data']['id']
    $created_user_id = response_data['data']['id'] # Store the user ID globally
  else
    raise 'User ID not found in the response'
  end
end

Then('the response create user status code should be {int}') do |expected_status_code|
  expect(@response.code).to eq(expected_status_code)
end




