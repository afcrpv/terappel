Feature: Saisie dossier
  In order to have dossiers in the db
  As a terappel user
  I want to be able to create new dossiers

  Background:
    Given a centre admin is logged in
    Given a correspondant from same user centre
    And a correspondant from centre "Bordeaux"

  Scenario: create dossier when code not found
    Given no dossiers exist with code "LY1111001"
    When I fill in the search field with "LY1111001"
    And I submit
    Then I should see the page for creating a new dossier
    And the code field should be pre-filled with "LY1111001"

  @javascript
  Scenario: open dossier when code is found
    Given 3 dossiers exist
    When I fill in the search field with "11"
    And I choose "LY111" in the autocomplete list
    Then the search field should contain "LY111"
    When I submit
    Then I should see the page for the dossier with code "LY111"

  @javascript
  Scenario: correspondant name autocomplete
    And I go to the new dossier page with code "LY1101001"
    When I fill in the correspondant field with "ma"
    And I choose "Martin - 69006 - Lyon" in the autocomplete list
    Then the correspondant field should contain "Martin - 69006 - Lyon"

  @javascript
  Scenario: correspondants list should contain same center items only
    When I go to the new dossier page with code "LY1101001"
    When I fill in the correspondant field with "ma"
    Then the correspondants list should contain "Martin - 69006 - Lyon"
    But the correspondants list should not contain "Martin - 69006 - Bordeaux"

  @javascript
  Scenario: on the fly correspondant modification
    When I go to the new dossier page with code "LY1101001"
    And I fill in the correspondant field with "ma"
    And I choose "Martin - 69006 - Lyon" in the autocomplete list
    Then the modify correspondant button should be visible
