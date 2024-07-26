Feature: Earning points from past flights
  As a Flying High Frequent Flyer program manager
  I want new members to be credited with points from their recent flights
  So that more people will join the programme
  Scenario: Eligible flight
    Given Todd has just joined the Frequent Flyer programme
    And Todd asks for the following flight to be credited to his account:
      | Flight Number | Flight Date | Status    |
      | FH-99         | 60 days ago | COMPLETED |
    Then the flight should be considered Eligible
  Scenario: Old flight
    Given Todd has just joined the Frequent Flyer programme
    And Todd asks for the following flight to be credited to his account:
      | Flight Number | Flight Date  | Status    |
      | FH-87         | 100 days ago | COMPLETED |
    Then the flight should be considered Ineligible
  Scenario: Not a Flying High flight
    Given Todd has just joined the Frequent Flyer programme
    And Todd asks for the following flight to be credited to his account:
      | Flight Number | Flight Date | Status    |
      | OH-101        | 60 days ago | COMPLETED |
    Then the flight should be considered Ineligible
  Scenario: Flights must be completed
    Given Todd has just joined the Frequent Flyer programme
    And Todd asks for the following flight to be credited to his account:
      | Flight Number | Flight Date | Status    |
      | FH-99         | 60 days ago | CANCELLED |
    Then the flight should be considered Ineligible
  Scenario: Flights must have taken place
    Given Todd has just joined the Frequent Flyer programme
    And Todd asks for the following flight to be credited to his account:
      | Flight Number | Flight Date    | Status    |
      | FH-99         | In 5 days time | CONFIRMED |
    Then the flight should be considered Ineligible