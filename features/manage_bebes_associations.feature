Feature: Manage bebes associations
  In order to do studies on teratogen agents
  As a terappel centre user
  I want to be able to manage bebes associations

  Background:
    Given a centre admin is logged in
    Given an existing malformation with libelle "Malformation1"
    Given an existing malformation with libelle "Malformation2"
    Given an existing pathologie with libelle "Pathologie1"
    Given an existing pathologie with libelle "Pathologie2"

  @javascript
  Scenario Outline: for new bebes show associations tokens if related select option is "oui"
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
  Scenario Outline: for existing bebes show associations tokens if related select option is "oui"
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
  Scenario Outline: adding associations to bebes for new dossiers
    When I add a new bebe for a dossier
    And I add <association> for the bebe
    Then I should see the added <association>
    Examples:
      |association|
      |malformations|
      |pathologies|

  @javascript
  Scenario: malformation and pathologies should not be mixed up in the summary
    When I add a new bebe for a dossier
    And I add malformations for the bebe
    And I add pathologies for the bebe
    Then the associations should not be mixed up

  @javascript
  Scenario Outline: adding association to bebes for existing dossiers
    Given an existing dossier with bebes
    And the bebe has <association>
    When I edit the dossier
    Then I should see the added <association>
    Examples:
      |association|
      |malformations|
      |pathologies|

  @javascript
  Scenario Outline: adding associations using treeview
    When I add a new bebe for a dossier
    And I add <association> using the treeview
    Then the added <association> should appear as tokens
    Examples:
      |association|
      |malformations|
      |pathologies|
