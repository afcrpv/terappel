describe "Grossesse", ->
  beforeEach ->
    @date_appel = "15/01/2012"
    @date_dernieres_regles = "01/01/2012"
    @date_debut_grossesse = "15/01/2012"
    @grossesse = new Grossesse(@date_appel, @date_dernieres_regles, @date_debut_grossesse)
    @complete_grossesse = new Grossesse(@date_appel, @date_dernieres_regles, "07/01/2012", "02/10/2012")

  it "requires a date_appel", ->
    expect(@grossesse.date_appel).toEqual(@date_appel)

  describe "#get_date_debut_grossesse", ->
    it "should calculate date from ddr when constructor argument not provided", ->
      expect(@grossesse.get_date_debut_grossesse()).toEqual("15/01/2012")
    it "should calculate date from dap when constructor argument not provided", ->
      grossesse = new Grossesse(@date_appel, "", "", "10/10/2012")
      expect(grossesse.get_date_debut_grossesse()).toEqual("15/01/2012")
    it "should use the constructor argument date", ->
      grossesse = new Grossesse(@date_appel, @date_dernieres_regles, "16/01/2012")
      expect(grossesse.get_date_debut_grossesse()).toEqual("16/01/2012")

  describe "#get_date_accouchement_prevu", ->
    describe "when dg is present and valid", ->
      it "should calculate dap from dg", ->
        expect(@grossesse.get_date_accouchement_prevu()).toEqual("10/10/2012")
    describe "when dg is empty or invalid", ->
      describe "when ddr is present and valid", ->
        it "should calculate dap from ddr", ->
          expect((grossesse = new Grossesse(@date_appel, @date_dernieres_regles, ""))
            .get_date_accouchement_prevu())
            .toEqual("10/10/2012")
      describe "when ddr is empty or invalid", ->
        it "should use the constructor argument dap date", ->
          grossesse = new Grossesse(@date_appel, "", "", "12/10/2012")
          expect(grossesse.get_date_accouchement_prevu()).toEqual("12/10/2012")

  describe "#age_grossesse", ->
    it "should return empty string when date appel is empty", ->
      invalid_grossesse = new Grossesse("")
      expect(invalid_grossesse.age_grossesse()).toBe("")
    describe "when ddr, dg and dap are valid", ->
      it "should use dg to calculate age grossesse", ->
        expect(@complete_grossesse.age_grossesse()).toBe(3)
    it "should use ddr to calculate when ddr only is valid", ->
      grossesse = new Grossesse(@date_appel, @date_dernieres_regles)
      expect(grossesse.age_grossesse()).toBe(2)
    it "should use dg to calculate when dg only is valid", ->
      grossesse = new Grossesse(@date_appel, "", "07/01/2012")
      expect(grossesse.age_grossesse()).toBe(3)
    it "should use dap to calculate when dap only is valid", ->
      grossesse = new Grossesse(@date_appel, "", "", "28/09/2012")
      expect(grossesse.age_grossesse()).toBe(4)

  describe "#calculateTermeNaissance jQuery plugin", ->
    beforeEach ->
      affix("#dossier_date_debut_grossesse")
      affix(".form-group #dossier_date_reelle_accouchement")
      affix(".form-group #dossier_terme")
      @ddra = $("#dossier_date_reelle_accouchement")
      @ddra.calculateTermeNaissance()

    it "calculate terme naissance", ->
      $("#dossier_date_debut_grossesse").val("15/01/2014")
      @ddra.val("15/10/2014").trigger("blur")
      expect($("#dossier_terme").val()).toBe "41"

    describe "when #dossier_terme is already filled", ->
      beforeEach ->
        $("#dossier_terme").val("41")
        @ddra.val("").trigger("blur")

      it "doesn't print an error message", ->
        expect($(".help-block")).not.toExist()

      it "doesn't add error class to inputs", ->
        expect($("#dossier_#{input}").parent()).not.toHaveClass("form-group has-error") for input in ["terme", "date_reelle_accouchement"]

    describe "when if #dossier_date_reelle_accouchement is blank", ->
      beforeEach ->
        $("#dossier_date_debut_grossesse").val("15/01/2014")
        @ddra.val("").trigger("blur")

      it "doesn't calculate terme naissance", ->
        expect($("#dossier_terme").val()).toBe ""

      it "assigns error class to input fields when calculation is impossible", ->
        expect($("#dossier_#{input}").parent()).toHaveClass("form-group has-error") for input in ["terme", "date_reelle_accouchement"]

      it "warns with a 'date is empty' message", ->
        expect($(".help-block")).toHaveText "calcul terme naissance impossible car date réelle d'accouchement vide"

  describe "with its #calculateGrossesse jQuery plugin", ->
    beforeEach ->
      $form = affix("form")
      $form.affix("input#dossier_#{id}") for id in ["date_appel", "date_dernieres_regles", "date_debut_grossesse", "date_accouchement_prevu", "age_grossesse"]
      $form.affix("#grossesse_date_messages")
      @date_dernieres_regles_field = $("#dossier_date_dernieres_regles")
      @date_debut_grossesse_field = $("#dossier_date_debut_grossesse")
      @date_accouchement_prevu_field = $("#dossier_date_accouchement_prevu")
      @age_grossesse_field = $("#dossier_age_grossesse")
    afterEach ->
      @date_dernieres_regles_field.val("")
      @date_debut_grossesse_field.val("")
      @date_accouchement_prevu_field.val("")
      @age_grossesse_field.val("")
    it "should warn when date_appel is empty", ->
      @date_dernieres_regles_field.calculateGrossesse().blur()
      expect($("#grossesse_date_messages").html())
        .toBe('<span class="calc_error">Calcul des dates de grossesse impossible, date appel vide</span>')
    describe "when a valid date_appel is provided", ->
      beforeEach ->
        $("#dossier_date_appel").val("15/01/2012")

      describe "when DDR is empty", ->
        beforeEach ->
          @date_dernieres_regles_field.calculateGrossesse().val("")
          @date_debut_grossesse_field.calculateGrossesse()
          @date_accouchement_prevu_field.calculateGrossesse()

        #start DDR empty DG empty
        describe "when DG is empty", ->
          beforeEach ->
            @date_debut_grossesse_field.val("")

          #start DDR empty DG empty DAP empty
          describe "when DAP is empty", ->
            beforeEach ->
              @date_accouchement_prevu_field.val("")
              @date_dernieres_regles_field.blur()
            it "should warn that calculation is impossible", ->
              expect($("#grossesse_date_messages").html())
                .toBe('<span class="calc_error">Calcul des dates de grossesse impossible, veuillez saisir au moins la date de dernières règles, de début grossesse ou date prévue d\'accouchement.</span>')
          #end DDR empty DG empty DAP empty

          #start DDR empty DG empty DAP entered
          describe "when DAP is entered", ->
            beforeEach ->
              @date_accouchement_prevu_field.val("10/10/2012")
              @date_accouchement_prevu_field.blur()
            it "should calculate DG from DAP", ->
              expect($("#dossier_date_debut_grossesse").val()).toBe("15/01/2012")
            it "should calculate SA from DG", ->
              expect($("#dossier_age_grossesse").val()).toBe("2")
          #end DDR empty DG empty DAP entered
        #end DDR empty DG empty

        #start DDR empty DG entered
        describe "when DG is entered", ->
          beforeEach ->
            @date_debut_grossesse_field.val("16/01/2012").blur()
          it "should calculate SA from DG", ->
            expect($("#dossier_age_grossesse").val()).toBe("2")
          it "should calculate DAP from DG", ->
            expect($("#dossier_date_accouchement_prevu").val()).toBe("11/10/2012")
        #end DDR empty DG entered
      #end DDR empty

      #start DDR entered
      describe "when a DDR is entered", ->
        beforeEach ->
          @date_dernieres_regles_field.calculateGrossesse().val("01/01/2012")

        describe "when DG is empty", ->
          beforeEach ->
            @date_dernieres_regles_field.blur()
          it "should calculate DG", ->
            expect(@date_debut_grossesse_field.val()).toBe("15/01/2012")
          it "should calculate DPA", ->
            expect(@date_accouchement_prevu_field.val()).toBe("10/10/2012")
          it "should calculate SA", ->
            expect(@age_grossesse_field.val()).toBe("2")
        #end DDR presendt DG empty

        describe "when DG is present", ->
          beforeEach ->
            @date_debut_grossesse_field.val("01/01/2012")
            @date_dernieres_regles_field.blur()
          it "should not change DG", ->
            expect(@date_debut_grossesse_field.val()).toBe("01/01/2012")
          it "should use DG to calculate DAP", ->
            expect(@date_accouchement_prevu_field.val()).toBe("26/09/2012")
          it "should use DG to calculate SA", ->
            expect(@age_grossesse_field.val()).toBe("4")
        #end DDR present DG present
      #end DDR present

      #start DDR present DAP present DG changed
      describe "when all dates are filled and DG is changed", ->
        beforeEach ->
          @date_dernieres_regles_field.val("01/01/2012")
          @date_accouchement_prevu_field.val("10/10/2012")
          @date_debut_grossesse_field.calculateGrossesse().val("28/12/2011").blur()
        it "should not change DDR", ->
          expect(@date_dernieres_regles_field.val()).toBe("01/01/2012")
        it "should recalculate DAP", ->
          expect(@date_accouchement_prevu_field.val()).toBe("22/09/2012")
        it "should recalculate age grossesse", ->
          expect(@age_grossesse_field.val()).toBe("5")
