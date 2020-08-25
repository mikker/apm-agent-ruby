Feature: TraceContext

  Scenario: An application receives a request
    Given an agent
    And an application
    When / is requested
    Then 1 metadata is sent
    And 1 transaction is sent
    And 0 spans are sent

