window.initComboboxAutocomplete = function() {
  $.widget( "ui.combobox", {
    _create: function() {
      var input,
        self = this,
        select = this.element.hide(),
        width_class = select.attr("class").match(/(span\d)+/)[0],
        selected = select.children( ":selected" ),
        value = selected.val() ? selected.text() : "",
        wrapper = this.wrapper = $( "<div>" )
          .addClass( "input-append" )
          .insertAfter( select );

      input = $( "<input>" )
        .attr("type", "text")
        .appendTo( wrapper )
        .val( value )
        .addClass( width_class )
        .autocomplete({
          delay: 0,
          minLength: 0,
          source: function( request, response ) {
            var matcher = new RegExp( $.ui.autocomplete.escapeRegex(request.term), "i" );
            response( select.children( "option" ).map(function() {
              var text = $( this ).text();
              if ( this.value && ( !request.term || matcher.test(text) ) )
                return {
                  label: text.replace(
                    new RegExp(
                      "(?![^&;]+;)(?!<[^<>]*)(" +
                      $.ui.autocomplete.escapeRegex(request.term) +
                      ")(?![^<>]*>)(?![^&;]+;)", "gi"
                    ), "<strong>$1</strong>" ),
                  value: text,
                  option: this
                };
            }) );
          },
          select: function( event, ui ) {
            ui.item.option.selected = true;
            self._trigger( "selected", event, {
              item: ui.item.option
            });
          },
          change: function( event, ui ) {
            if ( !ui.item ) {
              var matcher = new RegExp( "^" + $.ui.autocomplete.escapeRegex( $(this).val() ) + "$", "i" ),
                valid = false;
              select.children( "option" ).each(function() {
                if ( $( this ).text().match( matcher ) ) {
                  this.selected = valid = true;
                  return false;
                }
              });
              if ( !valid ) {
                // remove invalid value, as it didn't match anything
                $( this ).val( "" );
                select.val( "" );
                input.data( "autocomplete" ).term = "";
                return false;
              }
            }
          }
        })

      input.data( "autocomplete" )._renderItem = function( ul, item ) {
        return $( "<li></li>" )
          .data( "item.autocomplete", item )
          .append( "<a>" + item.label + "</a>" )
          .appendTo( ul );
      };

      $( "<button>" )
        .attr( "tabIndex", -1 )
        .attr( "title", "Tout montrer" )
        .attr( "type", "btn")
        .addClass( "btn")
        .append("<i class='icon-chevron-down'></i>")
        .appendTo( wrapper )
        .click(function(e) {
          e.preventDefault();
          // close if already visible
          if ( input.autocomplete( "widget" ).is( ":visible" ) ) {
            input.autocomplete( "close" );
            return;
          }

          // work around a bug (likely same cause as #5265)
          $( this ).blur();

          // pass empty string as value to search for, displaying all results
          input.autocomplete( "search", "" );
          input.focus();
        });
    },

    destroy: function() {
      this.wrapper.remove();
      this.element.show();
      $.Widget.prototype.destroy.call( this );
    }
  });
};
