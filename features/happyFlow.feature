Feature: Happy fLOW
    As a superadmin
    I want to create a booking for a patient
    So that I can schedule their visit

    @requires_auth
    # Scenario: Successfully create a new patient
    #     Given I have a valid patient payload
    #     When I send a POST request to "/admin/patients" with the patient payload
    #     Then the response status code create patient should be 201
    #     And the response body should contain the created patient details

    Scenario: Successfully create a booking for an existing patient
        Given I have a valid booking payload for an existing patient
        When I send a POST request to "/admin/v2/bookings" with the booking payload
        Then the response status code create booking should be 201
        And the response body should contain the created booking details

    Scenario: Successfully update booking status to "Arrive"
        Given I have an existing booking with status BOOKING
        When I send a PATCH request to "/admin/bookings/{bookingId}/status" with the status ARRIVED
        Then the response status arrive booking code should be 200
        And the response body should contain the updated status "ARRIVED"
    
    Scenario: Successfully update booking status to "on treatment"
        Given I have an existing booking with status ARRIVED
        When I send a PATCH request to "/admin/bookings/{bookingId}/status" with the status ON_TREATMENT
        Then the response status on treatment booking code should be 200
        And the response body should contain the updated status ON_TREATMENT

    Scenario: Successfully update a booking with status "COMPLETED"
        Given I have an existing booking with status ON_TREATMENT
        And I have a valid payload to update the booking status to COMPLETED
        When I send a PUT request to "/admin/v2/medical-records/{medicalRecordId}" with the payload medical record
        Then the response status COMPLETED booking code should be 200