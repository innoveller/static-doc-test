Feature: Earning Frequent Flyer points from flights
  In order to improve customer loyalty
  As an airline sales manager
  I want travellers to earn frequent flyer points when they fly with us

  Scenario: Flights within Europe earn 100 points
    Given Tara is a Frequent Flyer traveller
    When she completes a flight between Paris and Berlin
    Then she should earn 100 points

  Scenario: Flights outside Europe earn 1 point every 10 km
    Given the distance from London to New York is 5500 km
    And Tara is a Frequent Flyer traveller
    When she completes a flight between London and New York
    Then she should earn 550 points