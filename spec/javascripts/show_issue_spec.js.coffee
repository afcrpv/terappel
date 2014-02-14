describe "Show issue", ->
  beforeEach ->
    affix("input#dossier_evolution")
    affix(".help-block")
    issue_elements = affix(".issue")
    issue_elements.affix("#date_recueil_evol")
    issue_elements.affix("#date_reelle_accouchement")
    issue_elements.affix("#modaccouch")

  describe "when #dossier_evolution is already filled in", ->
    for issue in ['FCS', 'IVG', 'IMG', 'MIU', 'NAI']
      do ->
        it "shows .issue div when issue is #{issue}", ->
          $("#dossier_evolution").val(issue)
          $("#dossier_evolution").show_or_hide_issue_elements()
          expect($(".issue")).toBeVisible()

    it "hides .issue div when issue is other", ->
      $("#dossier_evolution").val("XXX")
      $("#dossier_evolution").show_or_hide_issue_elements()
      expect($(".issue")).toBeHidden()

    describe "when issue is 'NAI'", ->
      beforeEach ->
        $("#dossier_evolution").val("NAI")
        $("#dossier_evolution").show_or_hide_issue_elements()

      it "hides help message", ->
        expect($(".help-block")).toBeHidden()

      it "hides #date_recueil_evol", ->
        expect($("#date_recueil_evol")).toBeHidden()

      it "shows #modaccouch and #date_reelle_accouchement fields", ->
        expect($("##{field}")).toBeVisible() for field in ["modaccouch", "date_reelle_accouchement"]

    for issue in ['FCS', 'IVG', 'IMG', 'MIU']
      describe "when issue is '#{issue}'", ->
        do ->
          beforeEach ->
            $("#dossier_evolution").val(issue)
            $("#dossier_evolution").show_or_hide_issue_elements()

          it "shows help message", ->
            expect($(".help-block")).toBeVisible()

          it "shows #date_recueil_evol", ->
            expect($("#date_recueil_evol")).toBeVisible()

          it "hides #modaccouch and #date_reelle_accouchement fields", ->
            expect($("##{field}")).toBeHidden() for field in ["modaccouch", "date_reelle_accouchement"]


  describe "when #dossier_evolution changes", ->
    beforeEach ->
      $("#dossier_evolution").show_or_hide_issue_elements()

    for issue in ['FCS', 'IVG', 'IMG', 'MIU', 'NAI']
      do ->
        it "shows .issue div when issue is #{issue}", ->
          $("#dossier_evolution").val(issue).trigger("change")
          expect($(".issue")).toBeVisible()

    it "hides .issue div when issue is other", ->
      $("#dossier_evolution").val("XXX").trigger("change")
      expect($(".issue")).toBeHidden()

    describe "when issue is 'NAI'", ->
      beforeEach ->
        $("#dossier_evolution").val("NAI").trigger("change")

      it "hides help message", ->
        expect($(".help-block")).toBeHidden()

      it "hides #date_recueil_evol", ->
        expect($("#date_recueil_evol")).toBeHidden()

      it "shows #modaccouch and #date_reelle_accouchement fields", ->
        expect($("##{field}")).toBeVisible() for field in ["modaccouch", "date_reelle_accouchement"]

    for issue in ['FCS', 'IVG', 'IMG', 'MIU']
      describe "when issue is '#{issue}'", ->
        do ->
          beforeEach ->
            $("#dossier_evolution").val(issue).trigger("change")

          it "shows help message", ->
            expect($(".help-block")).toBeVisible()

          it "shows #date_recueil_evol", ->
            expect($("#date_recueil_evol")).toBeVisible()

          it "hides #modaccouch and #date_reelle_accouchement fields", ->
            expect($("##{field}")).toBeHidden() for field in ["modaccouch", "date_reelle_accouchement"]
