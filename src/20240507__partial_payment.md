---
layout: "layout.njk"
title: Partial Payment
---

# Title
Total amount for booking can be paid partially.

## Status
Accepted

## Context
With full payment, customers are needed to pay the whole amount before knowing the rooms they booked are actually 
available. When the rooms are available, there's no problem. But when the rooms are not available, support team will 
need to find another room or another hotel. If there is no match to customer's requirement, he/she will get the full 
amount they've paid to confirm booking. Full amount in average is nearly 100,000 MMK. Customers either don't trust the
system with this amount or when they do the system can barely fulfill their expectation because the system doesn't have 
the realtime allotment update.

## Decision
So we have decided to accept partial payment to increase the number of bookings and gain customer trust.

### How have we implemented it?
Every hotel has configuration for payable option. 

| Payment Percentage | Instant Confirmation |
|:------------------:|:--------------------:|
|        100%        |         Yes          |
|        20%         |          No          |


#### For 20% option
A customer can pay 20% of total amount as deposit and support team will confirm the room(s) 
availability. The customer will need to pay 80% only after the confirmation of room(s) availability. When the customer
has paid 100% of the total amount, he/she will get booking confirmation.

#### For 100% option
A customer can pay 100% of total amount and get instant booking confirmation. Support team will confirm room(s)
availability and the booking status can change accordingly.


## Constraints
Nothing can skip to booking confirmation (neither with api call nor an admin can confirm booking directly) without 
required percentage. Booking will be confirmed automatically once the required payment percentage has been fulfilled.

## Consequences
An admin need to handle payment transactions for remaining amount. 