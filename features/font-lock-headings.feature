Feature: Font lock headings
    Background:
    When the buffer is empty
    When I turn on robot-mode


  Scenario: Standard headings
    When I insert:
    """
    *** Settings ***
    """
    When I place the cursor after "Settings"
    Then current point should have the font-lock-keyword-face face

  # http://robotframework.org/robotframework/latest/RobotFrameworkUserGuide.html
  # says this is allowed as well
  @known-failure
  Scenario: Simple headings
    When I insert:
    """
    *Settings1
    * Settings2
    * Settings3 *
    """
    When I place the cursor before "Settings1"
    Then current point should have the font-lock-keyword-face face
    When I place the cursor before "Settings2"
    Then current point should have the font-lock-keyword-face face
    When I place the cursor before "Settings3"
    Then current point should have the font-lock-keyword-face face

  @known-failure
  Scenario: Pipe separated format headings
    When I insert:
    """
    | *Setting* | *Value*         |
    | Library   | OperatingSystem |
    """
    When I place the cursor before "Setting"
    Then current point should have the font-lock-keyword-face face
    When I place the cursor before "Value"
    Then current point should have the font-lock-keyword-face face
