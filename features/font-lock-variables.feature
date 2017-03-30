Feature: Font lock variables
    Background:
    When the buffer is empty
    When I turn on robot-mode

Scenario: Declaring variables
  When I insert:
  """
  ${HOST}         10.0.1.42
  @{paths}        more    args
  """
  When I place the cursor before "HOST"
  Then current point should have the font-lock-variable-name-face face
  When I place the cursor before "paths"
  Then current point should have the font-lock-variable-name-face face


Scenario: Using variables
  When I insert:
  """
  Remove Files    ${TEMPDIR}/f1.txt
  Remove Files    @{things}
  """
  When I place the cursor before "TEMPDIR"
  Then current point should have the font-lock-variable-name-face face
  When I place the cursor before "things"
  Then current point should have the font-lock-variable-name-face face
