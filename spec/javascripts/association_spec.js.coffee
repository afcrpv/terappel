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

  describe "when adding a new exposition", ->

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
          expect($("#exposition_message")).toHaveText("Vous devez remplir : produit_name")

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

        it "the table row should contain a modify link with the unique id", ->
          expect($(@table_row)).toContain ("a#modify_#{@plural_name_and_id}")

        it "the table row should contain a destroy link with the unique id", ->
          expect($(@table_row)).toContain ("a#destroy_#{@plural_name_and_id}")

        it "the table row should be marked with a 'live' class", ->
          expect($(@table_row)).toHaveClass("live")

        describe "clicking the destroy link", ->
          beforeEach ->
            $("#destroy_#{@plural_name_and_id}").click()

          it "should open a modal to confirm destruction", ->
            expect($("##{@plural_name_and_id}_destroy")).toBeVisible()

          describe "clicking the confirm destroy button", ->
            beforeEach ->
              $("#confirm-destruction-#{@plural_name_and_id}}").click()

            it "should remove the table row", ->
              expect(@table).not.toContain @table_row

            it "should remove the association fields", ->
              expect($(".nested-fields")).not.toExist()

            it "should destroy the modal", ->
              expect($(".modal")).not.toExist()

        it "the table row should contain the collected fields as cells", ->
          expect($(@table_row)).toContain ("td.produit_name")
          expect($(@table_row)).toContain ("td.indication")

        it "should show the add fields link", ->
          $add_link = $("a.add_fields[data-associations=#{@model_name}s]")
          expect($add_link).toHaveCss({display: "inline-block"})

  describe "when an exposition exists", ->
    beforeEach ->
      jasmine.getFixtures().fixturesPath = 'jasmine/fixtures'
      loadFixtures "existing_dossier_form"
      @table = $("table##{@model_name}s_summary")
      @table.prefillSummaryTable
        modelName: "#{@model_name}s"
      @model_id = "0"
      @plural_name_and_id = "#{@model_name}s_#{@model_id}"
      @table_row = "tr##{@plural_name_and_id}"

    it "nested fields should all be hidden", ->
      expect($(".nested-fields")).toBeHidden()

    it "summary table should be prefilled with exposition row id", ->
      expect(@table).toContain @table_row

    it "the table row should contain modify/destroy links with the unique id", ->
      expect($(@table_row)).toContain ("a#modify_#{@plural_name_and_id}")
      expect($(@table_row)).toContain ("a#destroy_#{@plural_name_and_id}")

    it "the table row should contain the collected fields as cells", ->
      produit_cell = "<td>ACICLOVIR</td>"
      indication_cell = "<td>HERPES</td>"
      expect($(@table_row)).toContainHtml produit_cell
      expect($(@table_row)).toContainHtml indication_cell

    describe "clicking the modify link", ->
      beforeEach ->
        $("#modify_#{@plural_name_and_id}").click()

      it "should disable itself", ->
        $("#modify_#{@plural_name_and_id}").click()
        expect($(".nested-fields")).toBeVisible()

      it "should toggle the related fields group", ->
        expect($(".nested-fields")).toBeVisible()

      it "should hide the add fields link", ->
        $add_link = $("a.add_fields[data-associations=#{@model_name}s]")
        expect($add_link).toBeHidden()

    describe "clicking the destroy link", ->
      beforeEach ->
        $("#destroy_#{@plural_name_and_id}").click()

      it "should open a modal to confirm destruction", ->
        expect($("##{@plural_name_and_id}_destroy")).toBeVisible()

      describe "clicking the confirm destroy button", ->
        beforeEach ->
          $("#confirm-destruction-#{@plural_name_and_id}}").click()

        it "should remove the table row", ->
          expect(@table).not.toContain @table_row

        it "should mark the associated model for destroy", ->
          expect($("input[type=hidden]").val()).toEqual("1")

        it "should destroy the modal", ->
          expect($(".modal")).not.toExist()
