describe "DureeExpo", ->
  it "calculates with provided arguments", ->
    duree_expo = new DureeExpo("periode_expo", "4", "8")
    expect(duree_expo.calculate()).toBe(4)

  it "returns an error message when #de or #a argument is blank", ->
    duree_expo = new DureeExpo("periode_expo", "", "8")
    expect(duree_expo.calculate()).toBe "Veuillez remplir les champs 'de (SA)' et 'à (SA)' !"

  describe "with its jquery plugin", ->
    beforeEach ->
      base = affix(".periode_expo")
      base.affix ".form-group input.de#de"
      base.affix ".form-group input.a.duree_calc#a"
      base.affix ".form-group input.duree#duree"
      $(".periode_expo").duree_expo()

    it "fills in input#duree with calc result when #de and #a are both filled", ->
      $("#de").val("4")
      $("#a").val("8").trigger("blur")
      expect($("#duree").val()).toBe("4")

    it "assigns error class to input fields when calculation is not done", ->
      $("#de").val("8")
      $("#a").val("4").trigger("blur")
      expect($("##{input}").parent()).toHaveClass("form-group has-error") for input in ["de", "a", "duree"]

    it "prints an error message when result has negative value", ->
      $("#de").val("8")
      $("#a").val("4").trigger("blur")
      expect($(".help-block")).toHaveText "La valeur 'de (SA)' est > à 'à (SA)' !"

    it "prints an error message when one of #de or #a is blank", ->
      $("#de").val("4")
      $("#a").val("").trigger("blur")
      expect($(".help-block")).toHaveText "Veuillez remplir les champs 'de (SA)' et 'à (SA)' !"
