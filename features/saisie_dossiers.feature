Feature: Saisie dossier
  In order to have dossiers in the db
  As a terappel user
  I want to be able to create new dossiers

  Background:
    Given a centre admin is logged in

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
