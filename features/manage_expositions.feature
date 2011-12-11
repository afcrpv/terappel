Feature: Manage expositions
  In order to do studies on teratogen agents
  As a terappel centre user
  I want to be able to manage expositions for dossiers

  Background:
    Given a centre admin is logged in
    Given an existing produit with name "ACICLOVIR"
    Given an existing expo_terme with name "T1"
    Given an existing indication with name "HERPES"

  @javascript
  Scenario: add row in expo summary
    When I add a new exposition for a dossier
    Then the added exposition should appear in the summary table

  @javascript @focus
  Scenario: update row in expo summary
    When I update an existing exposition for a dossier
    Then the corresponding row in the summary table should be updated
