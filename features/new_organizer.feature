Feature: Create a new organizer
  As an registered user
  I want to setup a organizer account
  So I be able to offer tours and guidebooks

  Scenario: User see an organizer
    Given I have a registered organizer
    When I go to the homepage
    Then I should see an organizer

  @javascript
  Scenario: Logged user create a organizer
    Given I am a registered user
    When I go to the homepage
    And I click in register guide
    And I fill the guide information
    And I click in finish 
    Then I see the guide profile page


  @javascript
  Scenario: Non logged user create a organizer
    Given I go to the homepage
    And I click in register guide
    And I fill the guide information
    And I click in finish 
    And I create an user account
    And I click in finish 
    Then I see the guide profile page