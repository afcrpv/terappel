describe "Association", ->
  beforeEach ->
    @model_name = "exposition"
    attributes =
      field1: "value1"
      field2: "value2"
      field3: "value3"
      field4: "value4"
    @exposition = new Association(@model_name, attributes)

  it "requires a model name", ->
    expect(@exposition.name).toBe(@model_name)

  it "requires an attributes list", ->
    expect(@exposition.attributes).toEqual
      field1: "value1"
      field2: "value2"
      field3: "value3"
      field4: "value4"

  describe "when the 'validate' button is clicked", ->
    beforeEach ->
      jasmine.getFixtures().fixturesPath = 'jasmine/fixtures'
      loadFixtures "dossier_form"
      @model_id = "0"
      @plural_name_and_id = "#{@model_name}s_#{@model_id}"
      @table = $("table##{@model_name}s_summary")
      @table_row = "tr##{@plural_name_and_id}"

    describe "and fields are all empty", ->
      beforeEach ->
        $(".validate_expo").validateAssociation(
          modelName: @model_name
          selectedFields: ["produit_name"]
          requiredFields: ["produit_name"]
        ).click()

      it "should not add a table row", ->
        expect(@table).not.toContain @table_row

      it "should show an error message", ->
        expect($("#exposition_message")).toHaveText("Vous devez remplir au moins un nom de produit")

    describe "when at least 1 field is filled", ->
      beforeEach ->
        $("#dossier_expositions_attributes_0_produit_name").val("tartampionate")
        $(".validate_expo").validateAssociation(
          modelName: @model_name
          selectedFields: ["produit_name", "indication"]
          requiredFields: ["produit_name"]
        ).click()

      it "should hide the association fields group", ->
        expect($(".nested-fields")).toBeHidden()

      it "should add a table row with a unique id", ->
        expect(@table).toContain @table_row

      it "the table row should contain modify/destroy links with the unique id", ->
        expect($(@table_row)).toContain ("a#modify_#{@plural_name_and_id}")
        expect($(@table_row)).toContain ("a#destroy_#{@plural_name_and_id}")

      it "the table row should contain the collected fields as cells", ->
        expect($(@table_row)).toContain ("td.produit_name")
        expect($(@table_row)).toContain ("td.indication")

      describe "clicking the modify link", ->
        beforeEach ->
          $("#modify_#{@plural_name_and_id}").click()

        it "should disable itself", ->
          $("#modify_#{@plural_name_and_id}").click()
          expect($(".nested-fields")).toBeVisible()

        it "should toggle the related fields group", ->
          expect($(".nested-fields")).toBeVisible()

        it "should hide the add fields link", ->
          expect($("a.add_fields[data-associations=#{@model_name}s]")).toBeHidden()

        describe "when association is bebes", ->

          xit "should prepare malformation and pathologies modals"

      describe "clicking the destroy link", ->
        beforeEach ->
          $("#destroy_#{@plural_name_and_id}").click()

        it "should open a modal to confirm destruction", ->
          expect($("##{@model_name}_destroy")).toBeVisible()

        describe "clicking the destroy button", ->
          beforeEach ->
            $("#confirm-destruction}").click()

          it "should remove the table row", ->
            expect(@table).not.toContain @table_row

          it "should mark the associated model for destroy", ->
            expect($("input[type=hidden]").val()).toEqual("1")

          it "should close the modal", ->
            expect($(".modal")).toBeHidden()
