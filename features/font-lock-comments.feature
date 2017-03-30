Feature: Font lock comments
  Background:
    When the buffer is empty
    When I turn on robot-mode


  Scenario: Normal comments
    When I insert:
    """
    # A comment
    """
    When I place the cursor after "A"
    Then current point should have the font-lock-comment-face face

  Scenario: Non-comment hashes
    When I insert:
    """
    Log Not \# A comment
    """
    When I place the cursor after "A"
    Then current point should have the font-lock-function-name-face face

  Scenario: Comment keyword comments
    When I insert:
    """
    My Test
        comment  foo
        Comment  capitalfoo
    """
    When I place the cursor before "foo"
    Then current point should have the font-lock-comment-face face
    When I place the cursor before "capitalfoo"
    Then current point should have the font-lock-comment-face face

  Scenario: Non-comment keywords
    When I insert:
    """
    My Test
        Non Comment  bar
    """
    When I place the cursor before "bar"
    Then current point should have no face
