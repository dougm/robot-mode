Feature: Rules for align-current
  Background:
    When the buffer is empty
    When I turn on robot-mode


  Scenario: Typical align-current usage
    When I insert:
    """
    My Test
        Log  fooooooooooooooooooooooooooo 123 456   bar
        Log differently  something else  bazzzzzz
    """
    When I call align-current
    Then I should see:
    """
    My Test
        Log                fooooooooooooooooooooooooooo 123 456    bar
        Log differently    something else                          bazzzzzz
    """

  @known-failure
  Scenario: Extra column on second line
    When I insert:
    """
    My Test
        Log  fooooooooooooooooooooooooooo 123 456
        Log differently  something else  bazzzzzz
    """
    When I call align-current
    Then I should see:
    """
    My Test
        Log                fooooooooooooooooooooooooooo 123 456
        Log differently    something else                          bazzzzzz
    """

  @known-failure
  Scenario: Extra column on first line
    When I insert:
    """
    My Test
        Log  fooooooooooooooooooooooooooo 123 456  bazzzzzz
        Log differently  something else
    """
    When I call align-current
    Then I should see:
    """
    My Test
        Log                fooooooooooooooooooooooooooo 123 456  bazzzzzz
        Log differently    something else
    """


  Scenario: Missing column on a middle line
    When I insert:
    """
    My Test
        Log  fooooooooooooooooooooooooooo 123 456  bazzzzzz
        Log differently  something else
        Log  oairestnoaiwnfotnars aorisetnl  bazzzzzz
    """
    When I call align-current
    Then I should see:
    """
    My Test
        Log                fooooooooooooooooooooooooooo 123 456    bazzzzzz
        Log differently    something else
        Log                oairestnoaiwnfotnars aorisetnl          bazzzzzz
    """
