Feature: Confirm a tour by the user
  As an registered user
  I want to confirm a reservation for a tour
  So I be able to live a new experience

  Scenario: User see a tour
    Given I have a registered tour
    When I go to the homepage
    Then I should see a tour
    
  @javascript
  Scenario: Logged user confirm a tour
    Given I am a registered user
    When I go to the homepage
    And I click on a tour
    And I click confirm reservation
    And I fill the credit card details and confirm
    Then I see the confirmation page
