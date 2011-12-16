Feature: Manage expositions
  In order to do studies on teratogen agents
  As a terappel centre user
  I want to be able to manage expositions for dossiers

  Background:
    Given a centre admin is logged in
    Given an existing produit with name "ACICLOVIR"
    Given an existing expo_terme with name "T1"
    Given an existing indication with name "HERPES"

  @javascript @focus
  Scenario: add row in expo summary
    When I add a new exposition for a dossier
    Then the added exposition should appear in the summary table

  @javascript
  Scenario: update row in expo summary
    When I update an existing exposition for a dossier
    Then the corresponding row in the summary table should be updated

  @javascript
  Scenario: update an existing row after adding a new row
    When I add a new exposition for a dossier
    And I add another exposition
    And I update the first exposition
    Then the first row should be updated

  @javascript
  Scenario: destroy an expo using link in expo summary row
    When I destroy an existing exposition for a dossier
    Then the corresponding row in the summary table should disappear
    And the expo should be ready to be destroyed

  @javascript
  Scenario: when modifying an existing dossier the expo summary table should be recreated
    Given an existing dossier with expositions
    When I edit the dossier
    Then the expo summary table should be filled up with existing expos
