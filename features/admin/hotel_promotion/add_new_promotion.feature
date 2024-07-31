Feature: Add New Hotel Promotion
    Background:
       Given Mary is logged in as Super Admin
         And she has selected the hotel to manage
         And she is on the new hotel promotion creating form with initial values
         | label               | required | initial value  |
         | Title               | true     | empty          |
         | Description         | true     | empty          |
         | Discount Percentage | true     | empty          |
         | Rate Plans          | true     | check box      |
         | Stay Start Date     | true     | empty          |
         | Stay End Date       | true     | empty          |

    Scenario: Adding new hotel promotion when there is no promotion for the hotel
        Given Mary has filled in all the required fields
        And There is no hotel promotion for the selected hotel
        When Mary submits the new hotel promotion named "Hotel Promotion 1"
        Then the new hotel promotion should be created successfully with auto-generated group id
        But the new hotel promotion should be inactive

    Scenario: Adding new hotel promotion with overlap date range when there is an active promotion
        Given There is an active hotel promotion in the selected hotel
          | title             | Stay Start Date | Stay End Date | Status   |
          | Hotel Promotion 1 | 2023-08-01      | 2023-08-31    | active   |
        When Mary submits the hotel promotion with named 'Hotel Promotion 2' and stay date range is '2023-08-15' to '2023-09-30'
        Then Adding the hotel promotion is rejected because there is an active promotion with overlapped date range
        And overlap date range error message should be displayed

    Scenario: Adding new hotel promotion with booking start/end date and minimum advance day
        Given Mary has filled in all the required fields
        And There is optional fields in hotel promotion
          | title               | required |
          | Booking Start Date  | false    |
          | Booking End Date    | false    |
          | Minimum Advance Day | false    |
          | Minimum Night       | false    |
          | Maximum Night       | false    |
        When Mary submits the hotel promotion with booking date range '2023-09-01' to '2023-10-31' and minimum advance day is 1
        Then the new hotel promotion should be created successfully with auto-generated group id
        And the promotion will be used only for bookings created between '2023-09-01' and '2023-10-31'
        And that booking should be created at least one day before check-in

    Scenario: Adding new hotel promotion with minimum/maximum number of night
        Given Mary has filled in all the required fields
        And filled minimum night to 1 and maximum night to 4
        When Marry submit the hotel promotion with minimum and maximum number of nights
        Then the new hotel promotion should be created successfully with auto-generated group id
        And the promotion will be used only for bookings staying between 1 and 4 nights



--- Should be converted into integration tests in the future, not necessarily belongs to BDD ---
Feature: Add New Hotel Promotion
    Background:
        Given Mary is logged in as Super Admin
        And she has selected the hotel to manage
        And there is a promotion activated in hotel promotion list
        | id | title             | discount_percentage | stay_start_date | stay_end_date | booking_start_date | booking_end_date | min_advance_day | min_night | max_night | rate_group_id | is_activate | is_reviewed | group_id | is_updated |
        | 1  | Hotel Promotion 1 | 10%                 | 2023-08-01      | 2023-08-31    | null               | null             | null            | null      | null      | { rg1 }       | true        | true        | ABC      | false      |

    Scenario: Adding new hotel promotion with advance day
        When Mary summit new 'Hotel Promotion 2' with 20% discount and define a rule that booking date need to advance at least 1 day with check-in date
        Then the promotion will be as follows
        | id | title             | booking_start_date | booking_end_date | min_advance_day |
        | 1  | Hotel Promotion 1 | null               | null             | null            |
        | 2  | Hotel Promotion 2 | 2023-09-01         | 2023-09-30       | 1               |

    Scenario: Adding new hotel promotion with a minimum stay of night
        When Mary summit new 'Hotel Promotion 3' with a rule that customer need to stay at least 2 nights
        Then the promotion will be as follows
        | id | title             | min_night |
        | 1  | Hotel Promotion 1 | null      |
        | 2  | Hotel Promotion 2 | null      |
        | 3  | Hotel Promotion 3 | 2         |

    Scenario: Adding new hotel promotion with a maximum stay of night
        When Mary summit new 'Hotel Promotion 4' with a rule that customer can stay up to 4 nights but no more promotion if customer book over 4 nights
        Then the promotion will be as follows
        | id | title             | max_night |
        | 1  | Hotel Promotion 1 | null      |
        | 2  | Hotel Promotion 2 | null      |
        | 3  | Hotel Promotion 3 | null      |
        | 4  | Hotel Promotion 4 | 4         |

    Scenario: Adding new promotion with existing stay start/end date or book start/end date
        When Marry summit new 'Hotel Promotion 5' with stay_start_date = 2023-08-01 and stay_end_date = 2023-09-30
        Then create promotion will be rejected because this date is overlapped with an another active promotion
            And overlap date range error message should be displayed

    Scenario: Adding new promotion with forget to select room type rate plan
        When Marry summit new 'Hotel Promotion 5' with forget to select room types
        Then create promotion will be rejected because room type is required field
            And need to select at least one
            And 'At least one rate plan must be selected' error message should be displayed