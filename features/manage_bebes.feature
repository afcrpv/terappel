Feature: Manage bebes
  In order to do studies on teratogen agents
  As a terappel centre user
  I want to be able to manage bebes associated to dossiers

  Background:
    Given a centre admin is logged in
    Given an existing malformation with libelle "Malfo1"
    Given an existing malformation with libelle "Malfo2"
    Given an existing pathologie with libelle "Patho1"
    Given an existing pathologie with libelle "Patho2"

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
  Scenario Outline: for new bebes show malformation/pathologie tokens if related select option is "oui"
    When I initialize a bebe for a dossier
    And I choose <option> from the <association> select
    Then the <association> tokens should be <state>
    Examples:
      |option|association|state|
      |"Oui" |"Malformation"|visible|
      |"Non" |"Malformation"|hidden|
      |"Oui" |"Pathologie"|visible|
      |"Non" |"Pathologie"|hidden|

  @javascript
  Scenario Outline: for existing bebes show malformation tokens if related select option is "oui"
    When I add a new bebe for a dossier
    And I choose <option> from the <association> select
    Then the <association> tokens should be <state>
    Examples:
      |option|association|state|
      |"Oui" |"Malformation"|visible|
      |"Non" |"Malformation"|hidden|
      |"Oui" |"Pathologie"|visible|
      |"Non" |"Pathologie"|hidden|

  @javascript
  Scenario: adding malformations to bebes for new dossiers
    When I add a new bebe for a dossier
    And I add malformations for the bebe
    Then I should see the added malformations

  @javascript
  Scenario: adding malformations to bebes for existing dossiers
    Given an existing dossier with bebes
    And the bebe has malformations
    When I edit the dossier
    Then I should see the malformations

  @javascript
  Scenario: adding malformations using treeview
    When I add a new bebe for a dossier
    And I add malformations using the treeview
    Then the added malformations should appear as tokens
