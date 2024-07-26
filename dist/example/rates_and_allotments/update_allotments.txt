Feature: Updating allotments
  Scenario: Updating allotments from "edit multiple"
    Given the logged-in admin is on edit rates dialog
    And the rate of any date of the previous two months is set
    And the average rate is the average value of the rates (except zero) of the previous two months
    When the admin set rates less than one third of average rate or greater than three times of the average rate
    Then warning message like "The rate seems abnormal. Please double check." should display.


  Scenario: Rates should be set or updated for dependent rate plans
    Given the base rate plans "Standard Rate" and the dependent rate plan "Early Bird Rate" based on "Standard Rate"
    And the rate of any date of the previous two months is set
    And the average rate is the average value of the rates (except zero) of the previous two months
    When the admin set rates less than one third of average rate or greater than three times of the average rate
    Then warning message like "The rate seems abnormal. Please double check." should display.







