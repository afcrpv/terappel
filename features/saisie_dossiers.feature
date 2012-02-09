Feature: Saisie dossier
  In order to have dossiers in the db
  As a terappel user
  I want to be able to create new dossiers

  Background:
    Given a centre admin is logged in
    And a correspondant from same user centre
    And a correspondant from centre "Bordeaux"
    And the evolutions "GEU FCS IVG IMG MIU NAI INC GNC"

  Scenario: create dossier when code not found
    Given no dossiers exist with code "LY1111001"
    When I fill in the search field with "LY1111001"
    And I submit
    Then I should see the page for creating a new dossier
    And the code field should be pre-filled with "LY1111001"

  @javascript
  Scenario: open dossier when code is found
    Given 3 dossiers exist
    When I fill in the search field with "11"
    And I choose "LY111" in the autocomplete list
    Then the search field should contain "LY111"
    When I submit
    Then I should see the page for the dossier with code "LY111"

  @javascript
  Scenario: correspondant name autocomplete
    And I go to the new dossier page with code "LY1101001"
    When I fill in the correspondant field with "ma"
    And I choose "Martin - 69006 - Lyon" in the autocomplete list
    Then the correspondant field should contain "Martin - 69006 - Lyon"

  @javascript
  Scenario: correspondants list should contain same center items only
    When I go to the new dossier page with code "LY1101001"
    When I fill in the correspondant field with "ma"
    Then the correspondants list should contain "Martin - 69006 - Lyon"
    But the correspondants list should not contain "Martin - 69006 - Bordeaux"

  @javascript
  Scenario: on the fly correspondant modification
    When I go to the new dossier page with code "LY1101001"
    And I fill in the correspondant field with "ma"
    And I choose "Martin - 69006 - Lyon" in the autocomplete list
    Then the modify correspondant button should be visible

  @javascript @focus
  Scenario Outline: show/hide mod accouch input when evolution is naissance
    When I go to the new dossier page with code "LY1101001"
    And I choose "<evolution>" as the evolution
    Then the mod accouch input should <condition> visible
    Examples:
      |evolution|condition|
      |GEU      |not be   |
      |FCS      |not be   |
      |IVG      |not be   |
      |IMG      |not be   |
      |MIU      |not be   |
      |INC      |not be   |
      |GNC      |not be   |
      |NAI      |be       |

  @javascript @calc_grossesse
  Scenario: don't calculate and alert if date appel is empty
    When I go to the new dossier page with code "LY1101001"
    And I calculate the dates grossesse
    Then I should see "Calcul impossible, date appel vide"

  @javascript @calc_grossesse
  Scenario: don't calculate and alert if ddr and dg are empty
    When I go to the new dossier page with code "LY1101001"
    And I fill in the date appel field with "01/01/2012"
    And I calculate the dates grossesse
    Then I should see "Calcul impossible, dates dernières règles et debut grossesse vides"

  @javascript @calc_grossesse
  Scenario: when ddr is empty, calculate dap using provided dg
    When I go to the new dossier page with code "LY1101001"
    And I fill in the date appel field with "01/01/2012"
    And I fill in the date debut grossesse field with "15/12/2011"
    And I calculate the dates grossesse
    Then the date accouchement prevue should be "09/09/2012"

  @javascript @calc_grossesse
  Scenario: with ddr provided, calculate age grossesse, dg and dap
    When I go to the new dossier page with code "LY1101001"
    And I fill in the date appel field with "01/01/2012"
    And I fill in the date dernieres regles field with "01/12/2011"
    And I calculate the dates grossesse
    Then the age grossesse should be "4"
    And the date debut grossesse should be "15/12/2011"
    And the date accouchement prevue should be "09/09/2012"
