Feature: Create new rate plan
  Background:
    Given Mary is logged in as super admin
      And the following rate plans are in rate plan list
      | name               | is_dependent | depend_on | is_active | guest_type |
      | Standard Rate Plan | false        |           | true      |  local     |

  Scenario: Mary creates new independent rate plan
    When Mary creates a new rate plan called 'Early Bird'
    Then rate plan list will be as follows
      | name               | is_dependent | depend_on | is_active | guest_type |
      | Standard Rate Plan | false        |           | true      |  local     |
      | Early Bird         | false        |           | false     |   any      |

  Scenario: Mary creates dependent rate plan
    When Mary creates a new rate plan called 'Last Minute'
      And she selects 'Standard Rate Plan' as original rate plan
    Then rate plan list will be as follows
      | name               | is_dependent | depend_on          | is_active |
      | Standard Rate Plan | false        |                    | true      |
      | Last Minute        | true         | Standard Rate Plan | false     |

  Scenario: Mary creates dependent rate plan
    When Mary creates a new rate plan called 'Last Minute'
    But she doesn't select original rate plan
    Then rate plan creation is rejected
      And an error message should be displayed

  Scenario: Mary creates new rate plan with existing name
    When Mary creates a new rate plan called 'Standard Rate Plan'
    Then rate plan creation will be rejected

  Scenario Outline: Mary creates new rate plan with existing guest_type
    When Mary creates a new rate plan with guest_type <guest_type>
    Then rate plan creation will be <status>
    Examples:
      | guest_type | status   |
      | local      | rejected |
      | foreigner  | accepted |

  Scenario Outline: Mary creates overlapping rate plans
    When Mary creates a new rate plan with guest_type <guest_type>
      And minimum advance days as <min_advance_days>
      And maximum advance days as <max_advance_days>
    Then rate plan creation will be <status>
    Examples:
      | guest_type | min_advance_days | max_advance_days | status    |
      | local      |   -              |   -              | rejected  |
      | local      | 7                | 21               | accepted  |
      | local      | 5                | 10               | rejected  |
      | local      | 0                | 1                | accepted  |
      | foreigner  |   -              |   -              | accepted  |
      | foreigner  | 14               | 28               | accepted  |
      | foreigner  | 5                | 10               | accepted  |
      | foreigner  | 7                | 21               | rejected  |




