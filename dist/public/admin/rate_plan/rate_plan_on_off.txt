Feature: On/Off rate plan
  Background:
    Given Mary is logged in as super admin
      And the following room types are in room type list:
      | name          | number_of_extra_bed |
      | Deluxe Room   |          0          |
      | Superior Room |          1          |

      And the following rate plans are in rate plan list:
      | name               | room_type_name | is_dependent | depend_on          | is_active |
      | Standard Rate Plan | Deluxe Room    | false        |   -                | false     |
      | Last Minute        | Deluxe Room    | true         | Standard Rate Plan | false     |
      | Default Rate       | Superior Room  | false        |   -                | false     |
      | Early Bird         | Superior Room  | true         | Default Rate       | false     |

  Scenario: Mary activates a dependent rate plan where its original rate plan is not active
    When Mary activates 'Last Minute' rate plan
    Then rate plan activation is rejected
      And an error message should be displayed

  Scenario: Mary activates an independent rate plan
    When Mary activates 'Standard Rate Plan'
    Then rate plan list will be as follows
      | name               | room_type_name | is_dependent | depend_on          | is_active |
      | Standard Rate Plan | Deluxe Room    | false        |   -                | true      |
      | Last Minute        | Deluxe Room    | true         | Standard Rate Plan | false     |
      | Default Rate       | Superior Room  | false        |   -                | false     |
      | Early Bird         | Superior Room  | true         | Default Rate       | false     |

    Scenario: Mary activates a dependent rate plan
      When Mary activates 'Last Minute' rate plan
      Then rate plan list will be as follows
        | name               | room_type_name | is_dependent | depend_on          | is_active |
        | Standard Rate Plan | Deluxe Room    | false        |   -                | true      |
        | Last Minute        | Deluxe Room    | true         | Standard Rate Plan | true      |
        | Default Rate       | Superior Room  | false        |   -                | false     |
        | Early Bird         | Superior Room  | true         | Default Rate       | false     |

    Scenario Outline: Mary activates a rate plan of 'Superior Room' without extra bed rate
      When Mary activate <rate_plan_name> plan
      Then rate plan activation is rejected
        And Mary should be asked to insert extra bed rate for <rate_plan_name>
      Examples:
        | rate_plan_name |
        | Default Rate   |
        | Early Bird     |

    Scenario Outline: Mary activates a rate plan of 'Superior Room' after inserting extra bed rate
      When Mary activates <rate_plan_1_name> plan
        And Mary inserted extra bed rate for <rate_plan_2_name> plan
      Then rate plan activation is <status>
        And <message> should be displayed to Mary
      Examples:
        | rate_plan_1_name | rate_plan_2_name | status   | message                                          |
        | Early Bird       | Default Rate     | rejected | "Its parent rate plan needs to be activated too" |
        | Default Rate     | Default Rate     | accepted | "Rate plan is activated successfully"            |
        | Early Bird       | Default Rate     | accepted | "Rate plan is activated successfully"            |

    Scenario: Mary deactivates a dependent rate plan
      Given the following rate plans are in rate plan list:
        | name               | room_type_name | is_dependent | depend_on          | is_active |
        | Standard Rate Plan | Deluxe Room    | false        |   -                | true      |
        | Last Minute        | Deluxe Room    | true         | Standard Rate Plan | true      |
      When Mary deactivates 'Last Minute' rate plan
      Then rate plan deactivation will be accepted
        And rate plan list will be as follows
          | name               | room_type_name | is_dependent | depend_on          | is_active |
          | Standard Rate Plan | Deluxe Room    | false        |   -                | true      |
          | Last Minute        | Deluxe Room    | true         | Standard Rate Plan | false     |

    Scenario: Mary deactivates an independent rate plan
      Given the following rate plans are in rate plan list:
        | name               | room_type_name | is_dependent | depend_on          | is_active |
        | Standard Rate Plan | Deluxe Room    | false        |   -                | true      |
        | Last Minute        | Deluxe Room    | true         | Standard Rate Plan | true      |
      When Mary deactivates 'Standard Rate Plan' rate plan
      Then rate plan deactivation will be accepted
      And all of its children will be deactivated
      And rate plan list will be as follows
        | name               | room_type_name | is_dependent | depend_on          | is_active |
        | Standard Rate Plan | Deluxe Room    | false        |   -                | false     |
        | Last Minute        | Deluxe Room    | true         | Standard Rate Plan | false     |
