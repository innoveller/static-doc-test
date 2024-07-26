Feature: Update commission
  Background:
    Given Mary is logged in as hotel admin
      And commission is set as following
      | commission_type | commission_value | is_currently_using |
      | PERCENTAGE      | 5.0              | true               |

  Scenario: Mary updates commission to a flat amount
    When Mary changes commission_type to FLAT
      And commission_value to MMK 1000
    Then commission table will be as follows
      | commission_type | commission_value | is_currently_using |
      | PERCENTAGE      | 5.0              | false              |
      | FLAT            | 1000             | true               |

  Scenario Outline: Mary updates commission to smaller values
    When Mary changes commission_type to <commission_type>
      And commission_value to <commission_value>
    Then updating commission will be rejected
      And an error message will be displayed

    Examples:
    | commission_type | commission_value |
    | PERCENTAGE      | 4.0              |
    | FLAT            | 990              |
    | PERCENTAGE      | 1.5              |
    | FLAT            | 500              |

  Scenario: Mary updates commission to a new percentage
    When Mary changes commission_type to PERCENTAGE
    And commission_value to 10.0 %
    Then commission table will be as follows
      | commission_type | commission_value | is_currently_using |
      | PERCENTAGE      | 5.0              | false              |
      | FLAT            | 1000             | false              |
      | PERCENTAGE      | 10.0             | true               |