Feature: Update Value Added Promotion
    Background:
       Given Mary is logged in as Super Admin
         And she has selected the hotel to manage
         And she is on the value added promotion updating form with initial values
         | label               | required | initial value                         |
         | Title               | true     | selected promotion title              |
         | Description         | true     | selected promotion description        |
         | Stay Start Date     | true     | selected promotion stay start date    |
         | Stay End Date       | true     | selected promotion stay end date      |
         | Short Message       | true     | selected promotion short message      |
         | Full Message        | true     | selected promotion full message       |
         | Room Types          | true     | check room type in selected promotion |

    Scenario: Updating value added promotion when there is an inactive promotion for the hotel
       Given There is an inactive value added promotion in the selected hotel
         | title       | Stay Start Date | Stay End Date | Default Short Message | Default Full Message   | Status   |
         | Promotion 1 | 2023-08-01      | 2023-08-31    | Swimming Pool         | Free Use Swimming Pool | inactive |
       When Mary extends stay end date in 'Promotion 1' to '2023-09-15'
       Then the existing value added promotion should be updated successfully
       And the existing value added promotion status should be still inactive

    Scenario: Activating value added promotion for the first time
       Given There is an inactive value added promotion in the selected hotel
         | title       | Stay Start Date | Stay End Date | Default Short Message | Default Full Message   | Status   |
         | Promotion 1 | 2023-08-01      | 2023-08-31    | Swimming Pool         | Free Use Swimming Pool | inactive |
       When Mary activates the 'Promotion 1'
       Then the existing value added promotion should be activated successfully

    Scenario: Updating room type using default message to custom message
       Given There is a value added promotion in the selected hotel
         | Room Type     | Message                |
         | Standard Room | Free Use Swimming Pool |
         | Deluxe Room   | Free Use Swimming Pool |
       When Mary changes default message to custom message in 'Standard Room' and add 'Gym' in message
       Then the message for 'Standard Room' should be changed to 'Swimming Pool and Gym'
       But the message for 'Deluxe Room' should not be changed

    Scenario: Activating hotel promotion for the first time that overlapped with another active promotion
       Given There are hotel promotion in the selected hotel
         | title       | Stay Start Date | Stay End Date | Default Short Message | Default Full Message   | Status   |
         | Promotion 1 | 2023-08-01      | 2023-08-31    | Swimming Pool         | Free Use Swimming Pool | active   |
         | Promotion 2 | 2023-08-15      | 2023-09-30    | Gym Room              | Free Use Gym Room      | inactive |
       When Mary activates the 'Promotion 2'
       Then the activation is rejected because there is an active promotion with overlapped date range
       And overlap date range error message should be displayed



--- Should be converted into integration tests in the future, not necessarily belongs to BDD ---
Feature: Update Value Added Promotion
    Background:
        Given Mary is logged in as Super Admin
        And she has selected the hotel to manage
        And there are promotions in hotel promotion list
        | id | title             | stay_start_date | stay_end_date | booking_start_date | booking_end_date | short_message_en | full_message_en  | applied_room_type_id | message_by_room_type                                        | is_activate | is_reviewed | group_id | is_updated |
        | 1  | Promotion 1       | 2023-08-01      | 2023-08-15    | null               | null             | 10% discount Spa | 10% discount Spa | { r1 }               | []                                                          | false       | false       | ABC      | false      |
        | 2  | Promotion 2       | 2023-09-01      | 2023-09-30    | 2023-09-01         | 2023-09-30       | Spa, Gym         | 10% Spa, Free Gym| { r1, r2 }           | [{roomTypeId: r1, shortMessage: Spa, fullMessage: 10% Spa}] | false       | false       | EFG      | false      |

    Scenario: Mary update short message and full message of unactivated promotion
        When Mary update short message and full message to 15% discount Spa in 'Promotion 1'
        Then short message and full message 10% discount Spa to 15% discount Spa in row id=1 as follows
        | title             | short_message_en | full_message_en  | is_activate | is_reviewed | group_id | is_updated |
        | Promotion 1       | 15% discount Spa | 15% discount Spa | false       | false       | ABC      | false      |
        | Promotion 2       | Spa, Gym         | 10% Spa, Free Gym| false       | false       | EFG      | false      |

    Scenario: Mary activate hotel promotion
        When Mary activate 'Hotel Promotion 1'
        Then both is_activate and is_reviewed are true in row id=1 as follows
        | title             | is_activate | is_reviewed | group_id | is_updated |
        | Promotion 1       | true        | true        | ABC      | false      |
        | Promotion 2       | false       | false       | EFG      | false      |

    Scenario: Mary update date range in existing promotion
        When Mary update 'Promotion 2' start stay date to 2023-08-01
        Then update promotion will be rejected because this date is overlapped with an another active promotion
        And overlap date range error message should be displayed

    Scenario: Mary extend promotion
        When Mary extend stay end date=2023-08-31 in 'Promotion 1' that already activated
        Then is_updated will be true in row id=1 and a new row will be created with the same group_id and new stay_end_date as follows
        | id | title             | stay_start_date | stay_end_date | booking_start_date | is_activate | is_reviewed | group_id | is_updated |
        | 1  | Promotion 1       | 2023-08-01      | 2023-08-15    | null               | true        | true        | ABC      | true       |
        | 2  | Promotion 2       | 2023-09-01      | 2023-09-30    | 2023-09-01         | false       | false       | EFG      | false      |
        | 3  | Promotion 1       | 2023-08-01      | 2023-08-30    | null               | true        | true        | ABC      | false      |

    Scenario: Mary update applied_room_type_id in 'Promotion 1' again
        When Mary add more room type in 'Promotion 1' that already activated
        Then is_updated will be true in row id=3 and a new row will be created with the same group_id and discount 30% will be created in new row as follows
        | id | title             | applied_room_type_id | is_activate | is_reviewed | group_id | is_updated |
        | 1  | Promotion 1       | { r1 }               | true        | true        | ABC      | true       |
        | 2  | Promotion 2       | { r1, r2 }           | false       | false       | EFG      | false      |
        | 3  | Promotion 1       | { r1 }               | true        | true        | ABC      | true       |
        | 4  | Promotion 1       | { r1, r2 }           | true        | true        | ABC      | false      |

    Scenario: Mary view value added promotion list
        Promotions with is_updated = false will be shown as follows
        | id | title             | stay_start_date | stay_end_date | booking_start_date | booking_end_date | short_message_en | full_message_en  | applied_room_type_id | message_by_room_type                                        | is_activate | is_reviewed | group_id | is_updated |
        | 2  | Promotion 2       | 2023-09-01      | 2023-09-30    | 2023-09-01         | 2023-09-30       | Spa, Gym         | 10% Spa, Free Gym| { r1, r2 }           | [{roomTypeId: r1, shortMessage: Spa, fullMessage: 10% Spa}] | false       | false       | EFG      | false      |
        | 4  | Promotion 1       | 2023-08-01      | 2023-08-30    | null               | null             | 15% discount Spa | 15% discount Spa | { r1, r2 }           | []                                                          | true        | true        | ABC      | false      |
