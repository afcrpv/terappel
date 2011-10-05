Feature: Manage dossiers
  In order to do studies on teratogen agents
  As a terappel centre admin
  I want to be able to manage dossiers

  Background:
    Given a centre exists
    And a user exists with username: "username", centre: the centre, role: "centre_admin"
    When I login with "username"

  Scenario: User creates a valid dossier
    When I follow "Nouveau Dossier"
    And I fill in the "activerecord.attributes.dossier.name" field with "Martin"
    And I fill in the "activerecord.attributes.dossier.date_appel" field with "31/01/2001"
    And I press the create dossier button
    Then 1 dossiers should exist
    And I should see "Dossier créé(e) avec succès."
    And I should see "Dossier #1"
    And I should see "Martin"
    And I should see "31/01/2001"

  Scenario: User tries to save an invalid dossier
    When I follow "Nouveau Dossier"
    And I press the create dossier button
    Then 0 dossiers should exist

  Scenario: User updates an existing dossier
    Given a dossier exists with centre: the centre, user: the user
    When I go to the centre's dossier page
    And I follow "Modifier"
    And I fill in the "activerecord.attributes.dossier.name" field with "Dupont"
    And I press the update dossier button
    Then I should see "Dossier mis(e) à jour avec succès."

  Scenario: User destroys an existing dossier
    Given a dossier exists with centre: the centre, user: the user
    When I go to the centre's dossier page
    And I follow "Détruire"
    Then 0 dossiers should exist
    And I should see "Dossier détruit(e) avec succès."
