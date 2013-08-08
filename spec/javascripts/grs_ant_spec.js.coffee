describe "Total grossesses number", ->
  beforeEach ->
    table = affix("table#grossesses_anterieures tbody")
    table.affix("tr td div.control-group div.controls input#dossier_grsant")
    row1 = table.affix("tr")
    for field in ["fcs", "geu", "miu"]
      row1.affix("td div.control-group div.controls input#dossier_#{field}")
    row2 = table.affix("tr")
    for field in ["ivg", "img", "nai"]
      row2.affix("td div.control-group div.controls input#dossier_#{field}")
    $("#grossesses_anterieures input").checkGrsantCoherence()

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
        expect($("span.help-inline")).toHaveText 'Saisie incorrecte, vérifiez la somme !'

      it "sets the error class to the sum input", ->
        expect($("#dossier_grsant").closest(".control-group")).toHaveClass("error")

     describe 'when entered sum equals calculated sum', ->
      beforeEach ->
        $("#dossier_grsant").val("2").blur()

       it "displays positive feedback", ->
          expect($("span.help-inline")).toHaveText 'Saisie correcte.'

      it "sets the success class to the sum input", ->
        expect($("#dossier_grsant").closest(".control-group")).toHaveClass("success")

  describe "when any fields are empty", ->
    beforeEach ->
      $("#dossier_grsant").blur()

    it "displays an appropriate warning", ->
      expect($("span.help-inline")).toHaveText 'Saisie incomplète, veuillez saisir tous les champs !'

    it "sets the warning class to the sum input", ->
      expect($("#dossier_#{field}").closest(".control-group")).toHaveClass("warning") for field in ["grsant", "fcs", "geu", "miu", "ivg", "img", "nai"]
