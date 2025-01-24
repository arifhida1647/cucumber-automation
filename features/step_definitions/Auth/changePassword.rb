require 'httparty'
require 'json'
require 'rspec'

Given('I have a valid Bearer token from ACCESS_TOKEN in env.rb for password change') do
  # Dynamically construct the file path to 'env.rb'
  env_file_path = File.join(File.dirname(__FILE__), '..', '..', 'support', 'env.rb')

  # Load the env.rb file to get the ACCESS_TOKEN constant
  load(env_file_path)  # This will load the content of env.rb and make ACCESS_TOKEN available

  # Assign the ACCESS_TOKEN value to @access_token
  @access_token = ACCESS_TOKEN
end

When('I send a POST request change password to {string}') do |url|
  # Define the current and new passwords to be used in the request
  payload = {
    "old_password" => "12345678",
    "new_password" => "12345678"
  }

  # Send a POST request to the specified URL
  response = HTTParty.post(url, 
                           headers: { "Authorization" => "Bearer #{@access_token}",
                                     'Content-Type' => 'application/json' },
                           body: payload.to_json)
  @response = response
end

Then('Success Password Change and the response status code should be {int}') do |status_code|
  # Check if the response status code matches the expected status code for password change
  expect(@response.code).to eq(status_code)
   # Parse response body to JSON
   response_body = JSON.parse(@response.body)
  
   # Extract access_token
   access_token = response_body.dig('data', 'access_token')
   if access_token
    env_file_path = File.join(File.dirname(__FILE__), '..', '..', 'support', 'env.rb')

    env_content = File.exist?(env_file_path) ? File.read(env_file_path) : ""
  
    # Menyaring baris yang mengandung 'ACCESS_TOKEN' dan menggantinya dengan token yang baru
    updated_content = env_content.gsub(/ACCESS_TOKEN = '.*'/, "ACCESS_TOKEN = '#{access_token}'")
  
    # Jika token belum ada di dalam file, tambahkan token baru
    unless updated_content.include?("ACCESS_TOKEN = '#{access_token}'")
      updated_content += "\nACCESS_TOKEN = ''"
    end
  
    # Menulis kembali konten yang sudah diupdate ke file
    File.open(env_file_path, 'w') do |file|
      file.puts updated_content
    end
   else
     raise "Access token not found in response!"
   end
end
