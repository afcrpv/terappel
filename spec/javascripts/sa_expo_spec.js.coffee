describe "SaExpo", ->
  it "calculates SA with correct arguments", ->
    terme_expo = new SaExpo("01/01/2014", "15/01/2014")
    expect(terme_expo.calculate()).toBe(4)

  it "returns an error message when expo_date argument is blank", ->
    terme_expo = new SaExpo("01/01/2014", "")
    expect(terme_expo.calculate()).toBe ""

  it "returns an error message when dg_date argument is blank", ->
    terme_expo = new SaExpo("", "15/01/2014")
    expect(terme_expo.calculate()).toBe "Veuillez remplir la date de debut de grossesse !"

  it "returns an error message when expo_date is before dg_date", ->
    terme_expo = new SaExpo("15/01/2014", "15/12/2013")
    expect(terme_expo.calculate()).toBe "La date d'exposition est antérieure à la date de debut de grossesse !"

  describe "with its jquery plugin", ->
    beforeEach ->
      affix "input#dossier_date_debut_grossesse"
      base = affix(".periode_expo")
      base.affix ".form-group input.de_date#de_date"
      base.affix ".form-group input.de#de"
      $(".periode_expo").expo_termes_calc($(".de_date"), $(".de"))

    it "fills in input#de with terme result when #de_date is filled", ->
      $("#dossier_date_debut_grossesse").val("01/01/2014")
      $("#de_date").val("15/01/2014").trigger("blur")
      expect($("#de").val()).toBe("4")

    it "assigns error class to input fields when calculation is impossible", ->
      $("#dossier_date_debut_grossesse").val("")
      $("#de_date").val("15/01/2014").trigger("blur")
      expect($("##{input}").parent()).toHaveClass("form-group has-error") for input in ["de", "de_date"]

    it "prints an error message when calculation is impossible", ->
      $("#dossier_date_debut_grossesse").val("")
      $("#de_date").val("15/01/2014").trigger("blur")
      expect($(".help-block")).toExist()

    it "prints an error message when result is negative", ->
      $("#dossier_date_debut_grossesse").val("15/01/2014")
      $("#de_date").val("15/12/2013").trigger("blur")
      expect($(".help-block")).toHaveText "La date d'exposition est antérieure à la date de debut de grossesse !"

    it "a prefilled SA field should not be blanked out if #de_date is blank", ->
      $("#dossier_date_debut_grossesse").val("15/01/2014")
      $("#de").val("2")
      $("#de_date").val("").trigger("blur")
      expect($("#de").val()).toBe "2"
