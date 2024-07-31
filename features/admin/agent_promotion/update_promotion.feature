Feature: Update Agent Promotion
    Background:
       Given Mary is logged in as Super Admin
       And she has selected the hotel to manage
       And she is on the agent promotion updating form with initial values
         | label               | required | initial value                          |
         | Title               | true     | selected promotion title               |
         | Discount Percentage | true     | selected promotion discount Percentage |
         | Stay Start Date     | true     | selected promotion stay start date     |
         | Stay End Date       | true     | selected promotion stay end date       |

    Scenario: Updating agent promotion when there is an inactive promotion for the hotel
       Given There is an inactive agent promotion in the selected hotel
         | title         | Stay Start Date | Stay End Date | Discount Percentage | Status     |
         | Sep Promotion | 2023-08-01      | 2023-08-31    | 10%                 | inactive   |
        When Mary updates the 'Sep Promotion' discount percentage to 20%
        Then the existing agent promotion should be updated successfully
        And the existing agent promotion status should be still inactive

    Scenario: Activating agent promotion for the first time
       Given There is an inactive agent promotion in the selected hotel
         | title         | Stay Start Date | Stay End Date | Discount Percentage | Status     |
         | Sep Promotion | 2023-08-01      | 2023-08-31    | 20%                 | inactive   |
       When Mary activates the 'Sep Promotion'
       Then the existing agent promotion should be updated successfully
       And the existing agent promotion status should be changed to active

    Scenario: Updating agent promotion that is already active in the selected hotel
       Given There is an active agent promotion in the selected hotel
         | title         | Stay Start Date | Stay End Date | Discount Percentage | Status     |
         | Sep Promotion | 2023-08-01      | 2023-08-31    | 20%                 | active     |
       When Mary extends stay end date in 'Sep Promotion' to '2023-09-30'
       Then the new version of agent promotion should be created successfully with the same group id
       And the existing agent promotion will be marked as overridden
       And the new version of the promotion will be used for upcoming bookings

    Scenario: Activating agent promotion for the first time that overlapped with another active promotion
       Given There are agent promotion in the selected hotel
         | title                    | Stay Start Date | Stay End Date | Discount Percentage | Status     |
         | Sep Promotion            | 2023-08-01      | 2023-08-31    | 20%                 | active     |
         | Raining Season Promotion | 2023-08-01      | 2023-10-31    | 10%                 | inactive   |
       When Mary activates the 'Raining Season Promotion'
       Then the agent promotion is rejected because there is an active promotion with overlapped date range
       And overlap date range error message should be displayed



--- Should be converted into integration tests in the future, not necessarily belongs to BDD --
Feature: Update Agent Promotion
    Background:
        Given Mary is logged in as Super Admin
        And she has selected the hotel to manage
        And there are promotions in agent promotion list
        | id | title                    | discount_percentage | stay_start_date | stay_end_date | is_activate | is_reviewed | group_id | is_updated |
        | 1  | Sep Promotion            | 10%                 | 2023-08-01      | 2023-08-15    | false       | false       | ABC      | false      |
        | 2  | Raining Season Promotion | 20%                 | 2023-09-01      | 2023-10-31    | false       | false       | DEF      | false      |

    Scenario: Mary update discount percentage of inactive promotion
        When Mary update 'Sep Promotion' discount_percentage to 20%
        Then discount_percentage will be updated to 20% in row id=1 as follows
        | id | title                    | discount_percentage | is_activate | is_reviewed | group_id | is_updated |
        | 1  | Sep Promotion            | 20%                 | false       | false       | ABC      | false      |
        | 2  | Raining Season Promotion | 20%                 | false       | false       | DEF      | false      |

    Scenario: Mary activate promotion
        When Mary activate 'Sep Promotion'
        Then both is_activate and is_reviewed are true in row id=1 as follows
        | id | title                    | is_activate | is_reviewed | group_id | is_updated |
        | 1  | Sep Promotion            | true        | true        | ABC      | false      |
        | 2  | Raining Season Promotion | false       | false       | DEF      | false      |

    Scenario: Mary update date range in existing promotion
        When Mary update 'Raining Season Promotion' start stay date=2023-08-01
        Then update promotion will be rejected because this date is overlapped with an another active promotion
        And overlap date range error message should be displayed

    Scenario: Mary extend promotion
        When Mary extend stay end date=2023-08-31 in 'Sep Promotion' that already activated
        Then is_updated will be true in row id=1 and a new row will be created with the same group_id and new stay_end_date as follows
        | id | title                    | stay_start_date | stay_end_date | is_activate | is_reviewed | group_id | is_updated |
        | 1  | Sep Promotion            | 2023-08-01      | 2023-08-15    | true        | true        | ABC      | true       |
        | 2  | Raining Season Promotion | 2023-09-01      | 2023-10-31    | false       | false       | DEF      | false      |
        | 3  | Sep Promotion            | 2023-08-01      | 2023-08-31    | true        | true        | ABC      | false      |

    Scenario: Mary update discount_percentage in 'Sep Promotion' again
        When Mary update discount_percentage to 30% in 'Sep Promotion' that already activated
        Then is_updated will be true in row id=3 and a new row will be created with the same group_id and discount 30% will be created in new row as follows
        | id | title                    | discount_percentage | is_activate | is_reviewed | group_id | is_updated |
        | 1  | Sep Promotion            | 20%                 | true        | true        | ABC      | true       |
        | 2  | Raining Season Promotion | 20%                 | false       | false       | DEF      | false      |
        | 3  | Sep Promotion            | 20%                 | true        | true        | ABC      | true       |
        | 4  | Sep Promotion            | 30%                 | true        | true        | ABC      | false      |

    Scenario: Mary view agent promotion list
        Promotions with is_updated = false will be shown as follows
        | title                    | discount_percentage | stay_start_date | stay_end_date | is_activate | is_reviewed | group_id | is_updated | 
        | Raining Season Promotion | 20%                 | 2023-09-01      | 2023-10-31    | false       | false       | DEF      | false      |
        | Sep Promotion            | 30%                 | 2023-08-01      | 2023-08-31    | true        | true        | ABC      | false      |