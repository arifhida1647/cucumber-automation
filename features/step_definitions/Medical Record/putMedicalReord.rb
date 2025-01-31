require 'httparty'
require 'faker'

Given("I have an existing booking with status ON_TREATMENT") do
  # Dynamically construct the file path to 'env.rb'
  env_file_path = File.join(File.dirname(__FILE__), '..', '..', 'support', 'env.rb')

  # Load the env.rb file to get the ACCESS_TOKEN constant
  load(env_file_path)  # This will load the content of env.rb and make ACCESS_TOKEN available
    
  # Assign the ACCESS_TOKEN value to @access_token
  @access_token = ACCESS_TOKEN

  @url_getBooking = "https://api.staging.satudental.com/admin/bookings/" + $booking_id.to_s
  # Mendapatkan ID Medical Record yang sudah ada
  @response_booking = HTTParty.get(
    @url_getBooking,
    headers: {"Authorization" => "Bearer #{@access_token}"}
  )
  response_booking_body = JSON.parse(@response_booking.body)
  @medical_record_id = response_booking_body['data']['medical_records']['id']
  puts response_booking_body
end

Given("I have a valid payload to update the booking status to COMPLETED") do
  @payload = {
    anamnesis: "Sakit gigi bagian atas",
    objective: nil,
    medications: nil,
    subjective: nil,
    diagnosis: [],
    procedures: [
        {
            procedure_id: 26,
            quantity: 1,
            actual_price: 500000,
            notes: "",
            locations: ["GIGI_15"]
        }
    ],
    referrals: {
        notes: ""
    },
    treatment_plans: [
        {
            procedure_id: 22,
            notes: ""
        }
    ],
    attachments: []
  }
end

When("I send a PUT request to {string} with the payload medical record") do |endpoint|
  endpoint = endpoint.gsub('{medicalRecordId}', @medical_record_id.to_s)
  @response = HTTParty.put(
    "https://api.staging.satudental.com#{endpoint}",
    body: @payload.to_json,
    headers: {"Authorization" => "Bearer #{@access_token}", 'Content-Type' => 'application/json' }
  )
end


Then("the response status COMPLETED booking code should be {int}") do |status_code|
  expect(@response.code).to eq(status_code)
end