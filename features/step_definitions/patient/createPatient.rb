require 'httparty'
require 'faker'

$patient_id = nil

Given("I have a valid patient payload") do
  @payload = {
    created_clinic_id: 119,
    identity_number: Faker::Number.unique.number(digits: 16).to_s,
    place_of_birth: "",
    date_of_birth: "14/03/2003",
    first_name: Faker::Name.first_name, # Nama depan di-random
    last_name: Faker::Name.last_name,   # Nama belakang di-random
    gender: "Male",
    email: Faker::Internet.unique.email,
    phone_number: "+628#{Faker::Number.unique.number(digits: 10)}",
    address: "",
    address_province: "",
    address_regency: "",
    address_sub_district: "",
    address_village: "",
    identity_type: "KTP",
    blood_type: "O",
    emergency_contact_name: "",
    emergency_contact_phone: nil,
    emergency_contact_relationship: nil,
    reference: nil,
    reference_from: ""
  }
end

When("I send a POST request to {string} with the patient payload") do |endpoint|
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

Then("the response status code create patient should be {int}") do |status_code|
  expect(@response.code).to eq(status_code)
end

Then("the response body should contain the created patient details") do
  response_body = JSON.parse(@response.body)
  expect(response_body['data']['identity_number']).to eq(@payload[:identity_number])
  expect(response_body['data']['email']).to eq(@payload[:email])
  expect(response_body['data']['phone_number']).to eq(@payload[:phone_number])
  $patient_id = response_body['data']['id']
end