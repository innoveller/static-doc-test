Feature: Add New Agent Promotion
  Background:
    Given Mary is logged in as Super Admin
    And she has selected the hotel to manage
    And she is on the new agent promotion creating form with initial values
      | label               | required | initial value  |
      | Title               | true     | empty          |
      | Discount Percentage | true     | empty          |
      | Stay Start Date     | true     | empty          |
      | Stay End Date       | true     | empty          |

  Scenario: Adding new agent promotion when there are none for the hotel
    Given Mary has filled in all the required fields
    And There are no agent promotion for the selected hotel
    When Mary submits the new agent promotion named "Sep Promotion"
    Then the new agent promotion should be created successfully with auto-generated group id
    But the new agent promotion should be inactive

  Scenario: Adding new agent promotion with overlap date range when there is an active promotion
    Given There is an active agent promotion in the selected hotel
      | title         | Stay Start Date | Stay End Date | Status   |
      | Sep Promotion | 2023-08-01      | 2023-08-31    | active   |
    When Mary submits the agent promotion with name 'Raining Season Promotion' and stay date range '2023-08-15' to '2023-09-30'
    Then Adding the agent promotion is rejected because there is an active promotion with overlapped date range
    And overlap date range error message should be displayed


--- Should be converted into integration tests in the future, not necessarily belongs to BDD ---
Feature: Add New Agent Promotion
    Background:
        Given Mary is logged in as Super Admin
        And she has selected the hotel to manage
        And there is a promotion activated in agent promotion list
        | id | title         | discount_percentage | stay_start_date | stay_end_date | is_activate | is_reviewed | group_id | is_updated |
        | 1  | Sep Promotion | 10%                 | 2023-08-01      | 2023-08-31    | true        | true        | ABC      | false      |

    Scenario: Adding new promotion
        When Mary submit new 'Raining Season Promotion' with 20% discount
        Then the promotion will be as follows
        | id | title                    | discount_percentage | stay_start_date | stay_end_date | is_activate | is_reviewed | group_id | is_updated |
        | 1  | Sep Promotion            | 10%                 | 2023-08-01      | 2023-08-31    | true        | true        | ABC      | false      |
        | 2  | Raining Season Promotion | 20%                 | 2023-09-01      | 2023-10-31    | false       | false       | EFG      | false      |

    Scenario: Adding new promotion with existing stay start/end date
        When Mary submit new 'Holiday Promotion' with stay_start_date = 2023-08-01 and stay_end_date = 2023-09-30
        Then the promotion will be rejected because this date is overlapped with an another active promotion
            And overlap date range error message should be displayed