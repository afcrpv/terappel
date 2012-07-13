describe "Grossesse", ->
  beforeEach ->
    @date_appel = "15/01/2012"
    @date_dernieres_regles = "01/01/2012"
    @date_debut_grossesse = "15/01/2012"
    @grossesse = new Grossesse(@date_appel, @date_dernieres_regles, @date_debut_grossesse)
    @invalid_grossesse = new Grossesse(@date_appel)

  it "requires a date_appel", ->
    expect(@grossesse.date_appel).toEqual(@date_appel)

  describe "#get_date_debut_grossesse", ->
    it "should calculate date when not provided", ->
      expect(@grossesse.get_date_debut_grossesse()).toEqual("15/01/2012")

    it "should use the constructor argument date", ->
      grossesse = new Grossesse(@date_appel, @date_dernieres_regles, "16/01/2012")
      expect(grossesse.get_date_debut_grossesse()).toEqual("16/01/2012")

  describe "#get_date_accouchement_prevu", ->
    it "should calculate date when not provided", ->
      expect(@grossesse.get_date_accouchement_prevu()).toEqual("10/10/2012")

    it "should use the constructor argument date", ->
      grossesse = new Grossesse(@date_appel, @date_dernieres_regles, "", "12/10/2012")
      expect(grossesse.get_date_accouchement_prevu()).toEqual("12/10/2012")

  describe "#age_lors_appel", ->
    it "should return null when date argument is invalid", ->
      expect(@invalid_grossesse.age_lors_appel("")).toBe(null)
    it "should calculate age 'grossesse en SA' at date_appel", ->
      expect(@grossesse.age_lors_appel(@date_dernieres_regles)).toBe(2)
