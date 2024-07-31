Feature: Amend Booking Stay Dates With Same Duration
  Background:
    Given John is logged in as super admin on Aug 24, 2023
    And there is a booking in the system
    | id | check_in_date | check_out_date | total_amount | discount | value_added_promotion |
    | b1 | Aug 28, 2023  | Aug 30, 2023   | MMK 50,000   | 5%       | Free E-Bike           |

  Scenario: Amend Booking With Same Total Amount
    When John changes check-in date to Aug 30, 2023
    But John cannot change check-out date as check-out date will automatically be generated for maintaining the same duration (in this case Sep 01, 2023)
    Then the calculated total amount for new stay dates is MMK 50,000 for new stay dates
    And the amendment will be allowed because of same total amounts

  Scenario: Amend Booking With Different Total Amount
    When John changes check-in date to Sep 01, 2023
    But John cannot change check-out date as check-out date will automatically be generated for maintaining the same duration (in this case Sep 03, 2023)
    Then the calculated total amount for new stay dates is MMK 70,000 for new stay dates
    And the amendment will be denied because of different total amounts

  Scenario: Amend Booking With Same Total Amount And Different Discounts
    When John changes check-in date to Aug 26, 2023
    But John cannot change check-out date as check-out date will automatically be generated for maintaining the same duration (in this case Aug 28, 2023)
    Then the calculated total amount for new stay dates is MMK 50,000 after applying 9% discount for new stay dates
    And the amendment will be allowed due to same total amounts regardless of different discount percentage

  Scenario: Amend Booking With Same Total Amount And Different Value Added Promotions
    When John changes check-in date to Aug 26, 2023
    But John cannot change check-out date as check-out date will automatically be generated for maintaining the same duration (in this case Aug 28, 2023)
    Then the calculated total amount for new stay dates is MMK 50,000
    And no value added promotion is available
    And the amendment will be allowed due to same total amounts regardless of different value added promotions