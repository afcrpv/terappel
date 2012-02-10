Feature: Manage dossiers
  In order to do studies on teratogen agents
  As a terappel centre admin
  I want to be able to manage dossiers

  Background:
    Given a centre admin is logged in

  Scenario: successful creation
    When I add a new dossier
    Then I should see the newly created dossier in the list

  Scenario: updating an existing dossier
    Given an existing dossier
    When I update the dossier with new data
    Then I should see the updated dossier in the list
