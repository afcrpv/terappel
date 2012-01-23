Feature: Manage bebes
  In order to do studies on teratogen agents
  As a terappel centre user
  I want to be able to manage bebes associated to dossiers

  Background:
    Given a centre admin is logged in

  @javascript
  Scenario: add row in bebes summary
    When I add a new bebe for a dossier
    Then the added bebe should appear in the summary table

  @javascript
  Scenario: update row in bebes summary
    When I update an existing bebe for a dossier
    Then the corresponding row in the bebes table should be updated

  @javascript
  Scenario: update an existing bebe after adding a new row
    When I add a new bebe for a dossier
    And I add another bebe
    And I update the first bebe
    Then the first bebe should be updated

  @javascript
  Scenario: destroy a bebe using link in row
    When I destroy an existing bebe for a dossier
    Then the corresponding bebe in the summary table should disappear
    And the bebe should be ready to be destroyed

  @javascript
  Scenario: when modifying an existing dossier the bebe summary table should be prefilled
    Given an existing dossier with bebes
    When I edit the dossier
    Then the bebe summary table should be filled up with existing bebes

  @javascript
  Scenario: hide add bebe button when a new bebe form is added
    When I initialize a bebe for a dossier
    Then the add bebe button should be hidden

  @javascript
  Scenario: show add bebe button when validating
    When I update an existing bebe for a dossier
    Then the add bebe button should be visible

  @javascript
  Scenario: hide add bebe button when a bebe form is being modified
    Given an existing dossier with bebes
    When I edit the dossier
    And I want to modify the bebe
    Then the add bebe button should be hidden

  @javascript
  Scenario: show add bebe button when removing a bebe form
    When I initialize a bebe for a dossier
    And I delete the initialized bebe
    Then the add bebe button should be visible
