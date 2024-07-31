Feature: Activating Room Type
  Background:
    Given Mary is logged in as Hotel Admin
    And she has selected the hotel to manage
    And there are three room types for the hotel
      | name             | active   |  active rate plans |  can activate     |
      | Standard Room    | active   |  1                 |  can activate     |
      | Deluxe Room      | inactive |  1                 |  can activate     |
      | Family Room      | inactive |  0                 |  cannot activate  |

  Scenario: Activating the room type with one or more active rate plans
    Given There is an active rate plan for "Deluxe Room"
    When Mary activates the room type "Deluxe Room"
    Then the room type should be active
    And the room type is now available for booking

  Scenario: Activating a rate plan for the room type with no active rate plan
    Given There is no active rate plan for "Family Room"
    And The room type cannot be activated
    When Mary activates a rate plan for "Family Room"
    Then the room type "Family Room" has one active rate plan
    And the room type "Family Room" can now be activated

  Scenario: Deactivating the active room type with one or more active rate plans
    Given The room "Standard Room" is active with one or more active rate plan
    When Mary deactivates the room type "Standard Room"
    Then the room type should be inactive
    And the room type is no longer available for booking

  Scenario: Deactivating the active room type when deactivating the last active rate plan
    Given The room "Standard Room" is active with only one active rate plan "Default Rate"
    When Mary deactivates the rate plan "Default Rate"
    Then the rate plan should be inactive
      And the room type "Standard Room" should be inactive
      And the room type is no longer available for booking