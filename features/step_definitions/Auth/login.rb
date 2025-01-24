require 'httparty'
require 'json'
require 'rspec'

Given('I have a valid username and password') do
  # Dynamically construct the file path to 'env.rb'
 env_file_path = File.join(File.dirname(__FILE__), '..', '..', 'support', 'env.rb')

 # Load the env.rb file to get the ACCESS_TOKEN constant
 load(env_file_path)  # This will load the content of env.rb and make ACCESS_TOKEN available
 @username = USERNAME
 @password = PASSWORD
 
  @base_url = 'https://api.staging.satudental.com/admin/auth/login'
  @headers = { 'Content-Type' => 'application/json' }
  @body = {
    email: @username,
    password: @password
  }.to_json
end

When('I log in with the username and password') do
  @response = HTTParty.post(@base_url, body: @body, headers: @headers)
end

Then('the status code should be {int}') do |status_code|
  expect(@response.code).to eq(status_code)
  puts "Response Code: #{@response.code}"

  # Parse response body to JSON
  response_body = JSON.parse(@response.body)
  
  # Extract access_token
  access_token = response_body.dig('data', 'access_token')
  if access_token
    env_file_path = File.join(File.dirname(__FILE__), '..', '..', 'support', 'env.rb')
  
    # Membaca file yang sudah ada
    env_content = File.exist?(env_file_path) ? File.read(env_file_path) : ""
  
    # Menyaring baris yang mengandung 'ACCESS_TOKEN' dan menggantinya dengan token yang baru
    updated_content = env_content.gsub(/ACCESS_TOKEN = '.*'/, "ACCESS_TOKEN = '#{access_token}'")
  
    # Jika token belum ada di dalam file, tambahkan token baru
    unless updated_content.include?("ACCESS_TOKEN = '#{access_token}'")
      updated_content += "\nACCESS_TOKEN = '#{access_token}'"
    end
  
    # Menulis kembali konten yang sudah diupdate ke file
    File.open(env_file_path, 'w') do |file|
      file.puts updated_content
    end
  
    puts "Access token updated in env.rb: #{access_token}"
  else
    raise "Access token not found in response!"
  end
end
