describe "Parite", ->

  describe "#coherence", ->
    it "returns true when argument sum equals calculated sum", ->
      parite = new Parite("2", ["1", "0", "0", "0", "0", "1"])
      expect(parite.coherence()).toBe true

  describe "with its jquery plugins", ->
    beforeEach ->
      affix(".form-group input#dossier_grsant.grsant_coherence")
      for field in ["fcs", "geu", "miu", "ivg", "img", "nai"]
        affix(".form-group input#dossier_#{field}.grsant_coherence")
      $(".grsant_coherence").checkGrsantCoherence()

    it "zero all related fields when grsant is filled with 0", ->
      $("#dossier_grsant").val("0")
       .zeroGrossesseFields()
       .blur()
      for field in ["fcs", "geu", "miu", "ivg", "img", "nai"]
        expect($("#dossier_#{field}").val()).toBe('0')

    describe "when all related fields are filled", ->
      beforeEach ->
        fields =
          fcs: "1"
          geu: "0"
          miu: "0"
          ivg: "0"
          img: "0"
          nai: "1"
        $("#dossier_#{key}").val(value) for key, value of fields

      describe "when entered sum differs from calculated sum", ->
        beforeEach ->
          $("#dossier_grsant").val("3").blur()

        it "displays a warning", ->
          expect($(".help-block")).toHaveText 'Saisie incorrecte, vérifiez la somme !'

        it "sets the error class to the sum input", ->
          expect($("#dossier_grsant").closest(".form-group")).toHaveClass("has-error")

       describe 'when entered sum equals calculated sum', ->
        beforeEach ->
          $("#dossier_grsant").val("2").blur()

         it "displays positive feedback", ->
            expect($(".help-block")).toHaveText 'Saisie correcte.'

        it "sets the success class to the sum input", ->
          expect($("#dossier_grsant").closest(".form-group")).toHaveClass("has-success")

    describe "when any fields are empty", ->
      beforeEach ->
        $("#dossier_grsant").blur()

      it "displays an appropriate warning", ->
        expect($(".help-block")).toHaveText 'Saisie incomplète, veuillez saisir tous les champs !'

      it "sets the warning class to the sum input", ->
        expect($("#dossier_#{field}").closest(".form-group")).toHaveClass("has-warning") for field in ["grsant", "fcs", "geu", "miu", "ivg", "img", "nai"]
