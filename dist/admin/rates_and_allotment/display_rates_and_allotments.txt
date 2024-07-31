Feature: Displaying rates and allotments

  Background:
    Given Mary is logged in as Hotel Admin
    And the "rates and allotments" editor page currently shows from "Sept 26, 2022" to "Oct 23, 2022"

  Scenario Outline: Displaying rates and allotments for 28 days from selected date
    When Mary selects <from date>
    And she views result
    Then rates and allotments should be display for 28days from <from date> to <to date>
    Examples:
      | from date     | to date       |
      | Sept 01, 2022 | Sept 28, 2022 |
      | Sept 15, 2022 | Oct 12, 2022  |
      | Dec 01, 2022  | Dec 28, 2022  |


  Scenario Outline : Rates and allotments should be displayed for previous/next 28 days
    Given Mary tries to view <previous/next> result
    Then the rates and allotments should be display for <previous/next> 28 days from <from date> to <to date>
    Examples:
      | previous/next | from date     | to date       |
      | previous      | Aug 29, 2022  | Sept 25, 2022 |
      | next          | Sept 27, 2022 | Oct 24, 2022  |


