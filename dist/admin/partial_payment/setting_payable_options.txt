Feature: Add Payable Option
  Background:
    Given Mary is logged in as agent admin
    And she has selected the hotel to manage
    And she is on 'Tax & Other' setting page with default payable option as follow
    | Initial Payment | Instant Confirmation |
    |     100%        |        Yes           |


  Scenario: Add new payable option
    Given Mary has clicked 'Add' button
    And a form asking initial percentage and instant confirmation status is visible
    And she has entered 20% for initial percentage and select 'No' for instant confirmation
    When she submit the form
    Then a new payable option should be created successfully
      | Initial Payment | Instant Confirmation |
      |     100%        |        Yes           |
      |      20%        |         No           |

  Scenario: Add new payable option with existing percentage
    Given Mary has clicked 'Add' button
    And a form asking initial percentage and instant confirmation status is visible
    And she has entered 100% for initial percentage and select 'No' for instant confirmation
    When she submit the form
    Then creation of payable option should be rejected

  Scenario: Edit existing payable option
    Given Mary has clicked 'Edit' button next to 20% option
    And a form with initial percentage '20%' and 'No' for instant confirmation is visible
    And she changes 20% to 50% and 'Yes' for instant confirmation
    When she submit the form
    Then editing of payable option should be accepted
      | Initial Payment | Instant Confirmation |
      |     100%        |        Yes           |
      |      50%        |        Yes           |

  Scenario: Delete payable option
    Given Mary has clicked 'Delete' button next to 50% option
    And a dialog will appear asking for confirmation
    When she chooses 'Confirm' to delete
    Then the payable option with 50% initial percentage will be deleted
      | Initial Payment | Instant Confirmation |
      |     100%        |        Yes           |
