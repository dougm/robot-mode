Feature: Font lock keywords
    Background:
    When the buffer is empty
    When I turn on robot-mode

  Scenario: Test header
    When I insert:
    """
    My Test
        Start process
    """
    When I place the cursor after "My"
    Then current point should have the font-lock-function-name-face face

  @known-failure
  Scenario: Keyword usage
    When I insert:
    """
    My Test
        Start process  ls  -l
    """
    When I place the cursor after "Start"
    Then current point should have the font-lock-preprocessor-face face
    When I place the cursor after "ls"
    Then current point should have no face
