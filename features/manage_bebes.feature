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

  @javascript @focus
  Scenario: adding malformations to bebes
    When I add a new bebe for a dossier
    And I add malformations for the bebe
    Then I should see the added malformations
