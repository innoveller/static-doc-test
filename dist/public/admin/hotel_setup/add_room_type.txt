Feature: Add Room Type
  Background:
    Given Mary is logged in as Hotel Admin
    And she has selected the hotel to manage
    And she is on the new room type creating form with initial values
      | label                   | required | initial value  |
      | Total Number Of Rooms   | true     | 0              |
      | Standard Occupancy      | true     | 2              |
      | Extra Beds Allowed      | true     | 0              |
      | Bed Type                | true     | [Select]       |
      | Guest Type              | true     | Local          |

  Scenario: Adding new room type when there are none for the hotel
    Given Mary has filled in all the required fields
    And There are no room types for the selected hotel
    When Mary submits the new room type name "Standard Room"
    Then the new room type should be created successfully
    But the new room type should not be active

  Scenario: Adding new room type when there is one with same name
    Given Mary has filled in all the required fields
    And There are existing room types in the selected hotel
      | Room Type        |
      | Standard Room    |
      | Deluxe Room      |
    When Mary submits the new room type name "Standard Room"
    Then Adding the new room type is rejected

  Scenario: Adding new room type when there is one with slightly similar name
    Given There are existing room types in the selected hotel
      | Room Type        |
      | Standard Room    |
      | Deluxe Room      |
    When Mary submits the new room type name "Standard Room Plus"
    Then Mary should see the confirmation form with existing room types with similar names
      | Room Type        |
      | Standard Room    |