require 'httparty'
require 'faker'

Given("I have an existing booking with status ON_TREATMENT") do
  @payload = {
      status: "ON_TREATMENT",
      clinic_room_id: 67,
      is_approve_consent: true,
      main_medical_personnel_id: 193,
      secondary_medical_personnel_id: nil
}
end


When("I send a PATCH request to {string} with the status ON_TREATMENT") do |endpoint|
  # Dynamically construct the file path to 'env.rb'
  env_file_path = File.join(File.dirname(__FILE__), '..', '..', 'support', 'env.rb')

  # Load the env.rb file to get the ACCESS_TOKEN constant
  load(env_file_path)  # This will load the content of env.rb and make ACCESS_TOKEN available
  
  # Assign the ACCESS_TOKEN value to @access_token
  @access_token = ACCESS_TOKEN
  endpoint = endpoint.gsub('{bookingId}', $booking_id.to_s)

  @response = HTTParty.patch(
    "https://api.staging.satudental.com#{endpoint}",
    body: @payload.to_json,
    headers: {"Authorization" => "Bearer #{@access_token}", 'Content-Type' => 'application/json' }
  )
end

Then("the response status on treatment booking code should be {int}") do |status_code|
  expect(@response.code).to eq(status_code)
end

Then("the response body should contain the updated status ON_TREATMENT") do 
  response_body = JSON.parse(@response.body)
  expect(response_body['data']['status']).to eq(@payload[:status])
end