Feature: Search dossier
  In order to quickly access dossiers
  As a terappel user
  I want to be able to search dossiers

  Background:
    Given a centre admin is logged in

  @javascript
  Scenario: search by dossier code
    Given 3 dossiers exist
    When I fill in the search field with "20"
    And I choose "LY-2011-1" in the autocomplete list
    Then the search field should contain "LY-2011-1"
    When I submit
    Then I should see the page for the dossier with code "LY-2011-1"
