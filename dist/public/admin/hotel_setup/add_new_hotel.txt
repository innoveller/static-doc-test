Feature: Add New Hotel
  Background:
    Given Mary is logged in as Super Admin
    And There are existing hotels in the system
      | Hotel Name       |  Town     |
      | Traders Hotel    |  Yangon   |
      | Farmers Hotel    |  Mandalay |

  Scenario: Adding new hotel
    When Mary submits new hotel named "Best Western Hotel" located in Yangon
    Then the new hotel should be created
    But the hotel should have pending status

  Scenario: Adding new hotel with same name and same town
    When Mary submits new hotel named "Traders Hotel" located in Yangon
    Then Submission is rejected

  Scenario: Adding new hotel with same name and different town
    When Mary submits new hotel named "Traders Hotel" located in Mandalay
    Then the new hotel should be created
    But the hotel should have pending status