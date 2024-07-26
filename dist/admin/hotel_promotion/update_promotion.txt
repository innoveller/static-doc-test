Feature: Update Hotel Promotion
    Background:
       Given Mary is logged in as Super Admin
         And she has selected the hotel to manage
         And she is on the hotel promotion updating form with initial values
         | label               | required | initial value                          |
         | Title               | true     | selected promotion title               |
         | Description         | true     | selected promotion description         |
         | Discount Percentage | true     | selected promotion discount percentage |
         | Rate Plans          | true     | selected promotion rate plans          |
         | Stay Start Date     | true     | selected promotion stay start date     |
         | Stay End Date       | true     | selected promotion stay end date       |

    Scenario: Updating hotel promotion when there is an inactive promotion for the hotel
       Given There is an inactive hotel promotion in the selected hotel
         | title             | Stay Start Date | Stay End Date | Discount Percentage | Status   |
         | Hotel Promotion 1 | 2023-08-01      | 2023-08-31    | 10%                 | inactive |
       When Mary updates the 'Hotel Promotion 1' discount percentage to 20%
       Then the existing hotel promotion should be updated successfully
       And the existing hotel promotion status should be still inactive

    Scenario: Activating hotel promotion for the first time
       Given There is an inactive hotel promotion in the selected hotel
         | title             | Stay Start Date | Stay End Date | Discount Percentage | Status   |
         | Hotel Promotion 1 | 2023-08-01      | 2023-08-31    | 20%                 | inactive |
       When Mary activates the 'Hotel Promotion 1'
       Then the existing hotel promotion status should be changed to active

    Scenario: Updating hotel promotion that is already active in the selected hotel
       Given There is an active hotel promotion in the selected hotel
         | title             | Stay Start Date | Stay End Date | Discount Percentage | Status |
         | Hotel Promotion 1 | 2023-08-01      | 2023-08-31    | 20%                 | active |
       When Mary extends stay end date in 'Hotel Promotion 1' to '2023-09-30'
       Then the new version of hotel promotion should be created successfully with the same group id
       And the existing hotel promotion will be marked as overridden
       And the new version of the promotion will be used for upcoming bookings

    Scenario: Updating booking start/end and advance day in hotel promotion that is already active in the selected hotel
       Given There is an active hotel promotion in the selected hotel
         | title             | Stay Start Date | Stay End Date | Discount Percentage | Booking Start Date | Booking End Date | Minimum Advance Day | Status |
         | Hotel Promotion 1 | 2023-08-01      | 2023-09-30    | 20%                 | null               | null             | null                | active |
       When Mary update booking date range '2023-08-01' to '2023-09-30' and minimum advance day to 1 in 'Hotel Promotion 1'
       Then the new version of hotel promotion should be created successfully with the same group id
       And the existing hotel promotion will be marked as overridden
       And the new version of the promotion will be used for upcoming bookings
       And the promotion will be used only for bookings created between '2023-08-01' and '2023-09-30'
       And that booking should be created at least one day before check-in

    Scenario: Updating minimum/maximum number of night in hotel promotion that is already active in the selected hotel
       Given There is an active hotel promotion in the selected hotel
         | title             | Stay Start Date | Stay End Date | Discount Percentage | Minimum Number Of Night | Maximum Number Of Night | Status |
         | Hotel Promotion 1 | 2023-08-01      | 2023-09-30    | 20%                 | null                    | null                    | active |
       When Mary update minimum number of night to 1 and maximum number of night to 3 in 'Hotel Promotion 1'
       Then the new version of hotel promotion should be created successfully with the same group id
       And the existing hotel promotion will be marked as overridden
       And the new version of the promotion will be used for upcoming bookings
       And the promotion will be used only for bookings staying between 1 and 3 nights

    Scenario: Activating hotel promotion for the first time that overlapped with another active promotion
       Given There are hotel promotion in the selected hotel
         | title             | Stay Start Date | Stay End Date | Discount Percentage | Status   |
         | Hotel Promotion 1 | 2023-08-01      | 2023-09-30    | 20%                 | active   |
         | Hotel Promotion 2 | 2023-08-01      | 2023-10-31    | 5%                  | inactive |
       When Mary activates the 'Hotel Promotion 2'
       Then the activation process should be rejected because there is an active promotion with overlapped date range
       And overlap date range error message should be displayed



--- Should be converted into integration tests in the future, not necessarily belongs to BDD ---
Feature: Update Hotel Promotion
    Background:
        Given Mary is logged in as Super Admin
        And she has selected the hotel to manage
        And there are promotions in hotel promotion list
        | id | title             | discount_percentage | stay_start_date | stay_end_date | booking_start_date | booking_end_date | min_advance_day | min_night | max_night | rate_group_id | is_activate | is_reviewed | group_id | is_updated
        | 1  | Hotel Promotion 1 | 10%                 | 2023-08-01      | 2023-08-15    | null               | null             | null            | null      | null      | { rg1 }       | false       | false       | ABC      | false
        | 2  | Hotel Promotion 2 | 5%                  | 2023-09-01      | 2023-09-30    | 2023-09-01         | 2023-09-30       | 1               | null      | null      | { rg1 }       | false       | false       | EFG      | false

    Scenario: Mary update discount percentage of unactivated promotion
        When Mary update discount_percentage to 20% in 'Hotel Promotion 1'
        Then discount_percentage will be updated to 20% in row id=1 as follows
        | title             | discount_percentage | is_activate | is_reviewed | group_id | is_updated
        | Hotel Promotion 1 | 20%                 | false       | false       | ABC      | false
        | Hotel Promotion 2 | 5%                  | false       | false       | EFG      | false

    Scenario: Mary activate hotel promotion
        When Mary activate 'Hotel Promotion 1'
        Then both is_activate and is_reviewed are true in row id=1 as follows
        | id | title             | is_activate | is_reviewed | group_id | is_updated
        | 1  | Hotel Promotion 1 | true        | true        | ABC      | false
        | 2  | Hotel Promotion 2 | false       | false       | EFG      | false

    Scenario: Mary update date range in existing promotion
        When Mary update 'Hotel Promotion 2' start stay date=2023-08-01
        Then update promotion will be rejected because this date is overlapped with an another active promotion
        And overlap date range error message should be displayed

    Scenario: Mary extend promotion
        When Mary extend stay end date=2023-08-31 in 'Hotel Promotion 1' that already activated
        Then is_updated will be true in row id=1 and a new row will be created with the same group_id and new stay_end_date as follows
        | id | title                    | stay_start_date | stay_end_date | is_activate | is_reviewed | group_id | is_updated
        | 1  | Hotel Promotion 1        | 2023-08-01      | 2023-08-15    | true        | true        | ABC      | true
        | 2  | Hotel Promotion 2        | 2023-09-01      | 2023-09-30    | false       | false       | DEF      | false
        | 3  | Hotel Promotion 1        | 2023-08-01      | 2023-08-31    | true        | true        | ABC      | false

    Scenario: Mary update discount_percentage in 'Hotel Promotion 1' again
        When Mary update discount_percentage to 30% in 'Hotel Promotion 1' that already activated
        Then is_updated will be true in row id=3 and a new row will be created with the same group_id and discount 30% will be created in new row as follows
        | id | title                    | discount_percentage | is_activate | is_reviewed | group_id | is_updated
        | 1  | Hotel Promotion 1        | 20%                 | true        | true        | ABC      | true
        | 2  | Hotel Promotion 2        | 5%                  | false       | false       | DEF      | false
        | 3  | Hotel Promotion 1        | 20%                 | true        | true        | ABC      | true
        | 4  | Hotel Promotion 1        | 30%                 | true        | true        | ABC      | false

    Scenario: Mary view hotel promotion list
        Promotions with is_updated = false will be shown as follows
        | id | title                    | discount_percentage | stay_start_date | stay_end_date | booking_start_date | booking_end_date | min_advance_day | min_night | max_night | rate_group_id | is_activate | is_reviewed | group_id | is_updated
        | 2  | Hotel Promotion 2        | 5%                  | 2023-09-01      | 2023-09-30    | null               | null             | null            | null      | null      | { rg1 }       | false       | false       | DEF      | false
        | 4  | Hotel Promotion 1        | 30%                 | 2023-08-01      | 2023-08-31    | 2023-09-01         | 2023-09-30       | 1               | null      | null      | { rg1 }       | true        | true        | ABC      | false