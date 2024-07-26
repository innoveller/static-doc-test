Feature: Add New Value Added Promotion
    Background:
       Given Mary is logged in as Super Admin
         And she has selected the hotel to manage
         And she is on the new value added promotion creating form with initial values
         | label               | required | initial value  |
         | Title               | true     | empty          |
         | Description         | true     | empty          |
         | Stay Start Date     | true     | empty          |
         | Stay End Date       | true     | empty          |
         | Short Message       | true     | empty          |
         | Full Message        | true     | empty          |
         | Room Types          | true     | check box      |

    Scenario: Adding new value added promotion when there is no promotion for the hotel
       Given Mary has filled in all the required fields
       And There is no value added promotion for the selected hotel
       When Mary submits the new value added promotion named "Promotion 1"
       Then the new value added promotion should be created successfully with auto-generated group id
       But the new value added promotion should be inactive

    Scenario: Adding new value added promotion with overlap date range when there is an active promotion
       Given There is an active value added promotion in the selected hotel
         | title       | Stay Start Date | Stay End Date | Status   |
         | Promotion 1 | 2023-08-01      | 2023-08-31    | active   |
       When Mary submits a new hotel promotion with named 'Promotion 2'
       And stay date range is '2023-08-15' to '2023-09-30'
       Then Adding the value added promotion is rejected because there is an active promotion with overlapped date range
       And overlap date range error message should be displayed



--- Should be converted into integration tests in the future, not necessarily belongs to BDD ---
Feature: Add New Value Added Promotion
    Background:
        Given Mary is logged in as Super Admin
        And she has selected the hotel to manage
        And there is a promotion activated and using default message in value added promotion list
        | id | title             | stay_start_date | stay_end_date | booking_start_date | booking_end_date | short_message_en | full_message_en | applied_room_type_id | message_by_room_type | is_activate | is_reviewed | group_id | is_updated
        | 1  | Promotion 1       | 2023-08-01      | 2023-08-31    | null               | null             | 10% discount Spa | 10% discount Spa| { r1 }              | []                   | true        | true        | ABC      | false

    Scenario: Adding new value added promotion with custom message
        When Mary summit new 'Promotion 2' with custom message for September
        Then custom message roomType will be store in message_by_room_type as Json list
        And the promotion will be as follows
        | id | title             | stay_start_date | stay_end_date | short_message_en | full_message_en  | applied_room_type_id | message_by_room_type                                      | is_activate  | is_reviewed  | group_id | is_updated
        | 1  | Promotion 1       | 2023-08-01      | 2023-08-31    | 10% discount Spa | 10% discount Spa | { r1 }              | []                                                         | true         | true         | ABC      | false
        | 2  | Promotion 2       | 2023-09-01      | 2023-09-30    | Spa, Gym         | 10% Spa, Free Gym| { r1, r2 }         | [{roomTypeId: r1, shortMessage: Spa, fullMessage: 10% Spa}] | false        | false        | EFG      | false

    Scenario: Adding new promotion with existing stay start/end date or book start/end date
        When Marry summit new 'Promotion 3' with stay_start_date = 2023-08-01 and stay_end_date = 2023-09-30
        Then create promotion will be rejected because this date is overlapped with an another active promotion
            And overlap date range error message should be displayed

    Scenario: Adding new promotion with forget to select room types
        When Marry summit new 'Promotion 3' with forget to select room types
        Then create promotion will be rejected because room type is required field
            And need to select at least one
            And 'At least one room type must be selected' error message should be displayed