require 'httparty'
require 'faker'
$booking_id = nil
Given("I have a valid booking payload for an existing patient") do
  # Mendapatkan tanggal hari ini
  today = Date.today

  # Menghasilkan jam acak antara 07:00 dan 09:00
  random_hour = rand(7..9)
  random_minute = rand(0..59)

  # Membuat start_time dan end_time
  start_time = Time.new(today.year, today.month, today.day, random_hour, random_minute, 0, "+07:00")
  end_time = start_time + 30 * 60 # Menambahkan 30 menit ke start_time

  @payload = {
    clinic_id: 119,
    patient_id:$patient_id,
    doctor_id: 193,
    start_time: start_time.iso8601, # Format ISO 8601
    end_time: end_time.iso8601,     # Format ISO 8601
    notes: nil,
    insurance_provider: nil,
    insurance_number: nil,
    procedures: [
      {
        id: 26,
        notes: nil
      }
    ],
    secondary_medical_personnel_id: nil,
    patient_insurance_id: nil
  }
end


When("I send a POST request to {string} with the booking payload") do |endpoint|
  # Dynamically construct the file path to 'env.rb'
  env_file_path = File.join(File.dirname(__FILE__), '..', '..', 'support', 'env.rb')

  # Load the env.rb file to get the ACCESS_TOKEN constant
  load(env_file_path)  # This will load the content of env.rb and make ACCESS_TOKEN available
  
  # Assign the ACCESS_TOKEN value to @access_token
  @access_token = ACCESS_TOKEN
  @response = HTTParty.post(
    "https://api.staging.satudental.com#{endpoint}",
    body: @payload.to_json,
    headers: {"Authorization" => "Bearer #{@access_token}", 'Content-Type' => 'application/json' }
  )
end

Then("the response status code create booking should be {int}") do |status_code|
  expect(@response.code).to eq(status_code)
end

Then("the response body should contain the created booking details") do
  response_body = JSON.parse(@response.body)
  expect(response_body['data']['start_time']).to eq(@payload[:start_time])
  expect(response_body['data']['end_time']).to eq(@payload[:end_time])
  $booking_id = response_body['data']['id']
end