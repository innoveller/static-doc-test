Feature: Scheduling
  Because scheduling is a huge functionality, this
  specification file describes only the most important
  high-level scenario.

  Scenario: Creating a meeting successfully
    Given Mike, a member of our team
    And it is not 2 pm yet
    When Mike chooses 2 p.m. as a start time for his meeting
    Then he should be able to save his meeting

  Scenario: Failing at creating a meeting
    Given Mike, a member of our team
    And it is already 3 pm
    When Mike chooses 2 p.m. as a start time for his meeting
    Then he should not be able to save his meeting

  Scenario: Cancelling a meeting
    Given a meeting by John and Anna at 4 p.m.
    And that it is 3 p.m. now
    When Anna cancels the meeting
    Then the event should be removed from the calendar
    And John should be notified about the canceled event
