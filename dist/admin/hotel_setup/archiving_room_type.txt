Feature: Archiving Room Type

  Background:
    Given Mary is logged in as Hotel Admin
    And she has selected the hotel to manage
    And there are three room types for the hotel
      | name          | active   | archived     |
      | Standard Room | active   | not archived |
      | Deluxe Room   | inactive | not archived |
      | Classic Room  | inactive | archived     |

  Scenario: Archiving the active room type with no current booking
    Given Room type "Standard Room" is active
    And there is no current bookings associated with the room type
    When Mary archives the room type
    Then the room type is inactive and archived
    And the room type is no longer accessible elsewhere except in archive list
    And the associated rate plans are also inactive

  Scenario: Archiving the active room type with one or more current bookings
    Given Room type "Standard Room" is active
    And there is one or more current bookings associated with the room type
    When Mary archives the room type
    Then the system shows error and warns that the room type cannot be archived

  Scenario: Archiving the inactive room type with no current booking
    Given Room type "Deluxe Room" is inactive
    And there is no current and future bookings associated with the room type
    When Mary archives the room type
    Then the room type is inactive and archived
    And the room type is no longer accessible elsewhere except in archive list
    And the associated rate plans are also inactive

  Scenario: Un-archiving the archived room type
    Given Room type "Classic Room" is archived
    When Mary un-archives the room type
    Then the room type is no longer archived
    But the room type is inactive
    And the associated rate plans are still inactive