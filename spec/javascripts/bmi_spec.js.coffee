describe "Bmi", ->
  beforeEach ->
    @weight = 55
    @size = 171
  it "calculates BMI with provided weight and size", ->
    bmi = new Bmi(@weight, @size)
    expect(bmi.calculate()).toBe(18)
  describe "with its jquery plugin #calculateBMI", ->
    beforeEach ->
      affix ("input#dossier_#{id}") for id in ["imc", "poids", "taille"]
      @imc_field = $("#dossier_imc")
      @weight_field = $("#dossier_poids")
      @size_field = $("#dossier_taille")
      @size_field.val('171')
      @weight_field.val('55')
    afterEach ->
      @imc_field.val("")
    it "fills up bmi field when weight field lose focus", ->
      @weight_field.calculateBMI("#dossier_imc")
      @weight_field.blur()
      expect(@imc_field.val()).toBe("18")
    it "fills up bmi field when size field lose focus", ->
      @size_field.calculateBMI("#dossier_imc")
      @size_field.blur()
      expect(@imc_field.val()).toBe("18")
