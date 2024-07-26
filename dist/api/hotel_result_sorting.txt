Feature: Hotel Result Sorting
  Background:
    Given ShweBooking is a client to fetch result from api
      And available hotels as below
        | hotel_name | commission_value | minimum_amount |
        | Hotel A    |     MMK 2000     |     300        |
        | Hotel B    |       10 %       |    1000        |
        | Hotel C    |     MMK 1000     |     500        |

  Scenario: No Sorting (location_type = 'town' or 'attraction')
    When ShweBooking fetch hotels without defining specific sorting order
    Then hotels in result will be sorted by maximum commission percentage
      And ShweBooking receives hotel list leading with the hotel which has the maximum commission percentage
        | hotel_name | commission_value | minimum_amount |
        | Hotel B    |       10 %       |    1000        |
        | Hotel A    |     MMK 2000     |     300        |
        | Hotel C    |     MMK 1000     |     500        |

  Scenario: Sort by price ASCENDING
    When ShweBooking fetch hotels with sort_by_price as ascending
      Then hotels in result will be sorted by the smallest minimum amount
        And ShweBooking receives hotel list as follows
          | hotel_name | commission_value | minimum_amount |
          | Hotel A    |     MMK 2000     |     300        |
          | Hotel C    |     MMK 1000     |     500        |
          | Hotel B    |       10 %       |    1000        |

  Scenario: Sort by price DESCENDING
    When ShweBooking fetch hotels with sort_by_price as descending
    Then hotels in result will be sorted by the largest minimum amount
      And ShweBooking receives hotel list as follows
        | hotel_name | commission_value | minimum_amount |
        | Hotel B    |       10 %       |    1000        |
        | Hotel C    |     MMK 1000     |     500        |
        | Hotel A    |     MMK 2000     |     300        |

  Scenario: Search by hotel
    When ShweBooking fetch hotels by 'Hotel C' (location_type = 'hotel')
    Then searched hotel will be on top of the list
      And following hotels are sorted by maximum commission percentage
      And ShweBooking receives hotel list as follows
        | hotel_name | commission_value | minimum_amount |
        | Hotel C    |     MMK 1000     |     500        |
        | Hotel B    |       10 %       |    1000        |
        | Hotel A    |     MMK 2000     |     300        |

  Scenario: Filter by price range
    When ShweBooking fetch hotels with price range from 500 to 1000
    Then hotels with minimum amount from 500 to 1000 will be selected
      And resulted hotels will be sorted by commission_value
      And ShweBooking receives hotel list as follows
        | hotel_name | commission_value | minimum_amount |
        | Hotel B    |       10 %       |    1000        |
        | Hotel C    |     MMK 1000     |     500        |

  Scenario: Filter by price range with Sort by price ASCENDING
    When ShweBooking fetch hotels with price range from 500 to 1000
      And sort_by_price as ascending
    Then hotels with minimum amount from 500 to 1000 will be selected
    And resulted hotels will be sorted by the smallest minimum_amount
    And ShweBooking receives hotel list as follows
      | hotel_name | commission_value | minimum_amount |
      | Hotel C    |     MMK 1000     |     500        |
      | Hotel B    |       10 %       |    1000        |
