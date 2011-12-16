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
