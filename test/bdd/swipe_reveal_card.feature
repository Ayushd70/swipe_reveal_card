Feature: Swipe Reveal Card
  As a user
  I want to swipe a card to reveal actions
  So that I can edit or delete items quickly

  Scenario: Plain card shows its child without swipe actions
    Given a plain swipe reveal card with text {'Hello card'}
    Then I see {'Hello card'} text
    And the card is not swipable

  Scenario: Card with actions shows action labels
    Given a swipe reveal card with Edit and Delete actions labeled {'Swipe me'}
    Then I see {'Swipe me'} text
    And I see {'Edit'} text
    And I see {'Delete'} text
    And the card is swipable

  Scenario: Swiping left and tapping Edit invokes the action
    Given a swipe reveal card with Edit and Delete actions labeled {'Swipe me'}
    When I swipe the card left
    And I tap {'Edit'} text
    Then the {'Edit'} action was invoked

  Scenario: Tapping the card body invokes onTap
    Given a tappable swipe reveal card with text {'Tap me'}
    When I tap {'Tap me'} text
    Then the card onTap was invoked
