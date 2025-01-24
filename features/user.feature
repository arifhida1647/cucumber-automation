Feature: Create user Endpoint
  As a user of the system
  I want to be able to create a new user
  So that I can manage user data effectively

  @requires_auth
  Scenario: Successfully create a user with valid data
    Given I have valid user data
    When I send a POST request to the endpoint create the user data
    Then the response create user status code should be 201

 
  Scenario: Successfully update a user with valid data
    Given I have valid user update data
    When I send a PUT request to the endpoint update the user data
    Then the response update user status code should be 200

  
  Scenario: Successfully Change status a user with valid data
    Given I have valid user status data
    When I send a PATCH request to the endpoint update status user data
    Then the response update status user status code should be 200
  
  Scenario: Successfully Change Password a user with valid data
    Given I have valid change password user data
    When I send a POST request to the endpoint change password user data
    Then the response change password user status code should be 200
  
  Scenario: Successfully delete a user with valid data
    Given I have valid user delete data
    When I send a DELETE request to the endpoint delete user data
    Then the response delete user status code should be 200
