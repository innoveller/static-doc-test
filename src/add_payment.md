---
layout: "layout.njk"
title: Partial Payment
---

Feature: Add Payment To Tentative Booking
  Background:
    Given Mary is logged in as agent admin
    And she is viewing the tentative booking list for today
    And she has selected a tentative booking for which customer has paid 20% as initial payment
    And she cross-checks the selected room availability with hotel
    And the hotel confirms the room availability

  Scenario: Add Payment
    Given the hotel confirms the room availability
    And Mary contacts the customer to request the remaining 80% payment
    When the customer pays the remaining amount
    Then Mary clicks 'Add Payment' button in tentative booking details page
    And fills the payment information
    And submits the payment information
    Then payment information should be added successfully
    And tentative booking will be confirmed immediately

  Scenario: Refund Payment
    Given the hotel confirms the room being sold out
    And Mary contacts the customer to inform that the room has been sold out
    When the customer wants his/her 20% back
    Then Mary should start refunding process immediately
