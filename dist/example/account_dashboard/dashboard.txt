Feature: Account Holder dashboard

  Scenario: Account owners should be able to see their balance at a glance
    Given Sam has the following accounts:
      | Type    | Number | Current Balance | Pending Transaction |
      | Current | 123456 | $530.00         | $-200.00            |
      | Savings | 234567 | $2500           |                     |
    When he views his account summary
    Then he should see the balance and pending transactions for each account:
      | Type     | Current Balance | Pending Transactions | Available |
      | Current  | $530.00         | $-200.00             | $330.00   |
      | Savings  | $2500           |                      | $2500.00  |