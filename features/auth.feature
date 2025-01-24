Feature: Auth Feature
  As a user
  I want to log in to the application
  So that I can access my account

  Scenario: Successful login with valid credentials
    Given I have a valid username and password
    When I log in with the username and password
    Then the status code should be 200

  Scenario: Successfully get account information with a valid token 
    Given I have a valid Bearer token from ACCESS_TOKEN in env.rb for get info by me
    When I send a GET request to "https://api.staging.satudental.com/admin/me"
    Then Success GET info by me and the response status code should be 200 
    And the response should contain my account information

  Scenario: Successful password change with valid credentials
    Given I have a valid Bearer token from ACCESS_TOKEN in env.rb for password change
    When I send a POST request change password to "https://api.staging.satudental.com/admin/change-password" 
    Then Success Password Change and the response status code should be 200
    
  Scenario: Successful logout with a valid token 
    Given I have a valid Bearer token from ACCESS_TOKEN in env.rb for logout
    When I send a POST request logout to "https://api.staging.satudental.com/admin/auth/logout"
    Then Success Logout and the response status code should be 200
    And the response should indicate a successful logout message