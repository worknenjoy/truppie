Feature: Confirm a guidebook by the user
  As an registered user
  I want to confirm a reservation for a guidebook
  So I be able to receive a tour plan by the organizer

  Scenario: User see a guidebook
    Given I have a registered tour
    When I go to the homepage
    Then I should see a guidebook

  @javascript
  Scenario: Logged user confirm a guidebook
    Given I am a registered user
    When I go to the homepage
    And I click on a guidebook
    And I click confirm reservation
    And I fill the credit card details and confirm
    Then I see the confirmation page
