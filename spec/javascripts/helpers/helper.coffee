root = @

root.context = root.describe
root.xcontext = root.xdescribe

beforeEach ->
  @addMatchers
    toHaveText: (text) ->
      trimmedText = $.trim(@actual.text())
      if text and $.isFunction(text.test)
        text.test(trimmedText)
      else
        trimmedText is text
    toBeHidden: ->
      @actual.is(':hidden')
    toBeVisible: ->
      @actual.is(':visible')
    toExist: ->
      $(document).find(@actual).length
    toContain: (selector) ->
      @actual.find(selector).length
    toContainHtml: (html) ->
      actualHtml = @actual.html()
      expectedHtml = $('<div/>').append(html).html()
      actualHtml.indexOf(expectedHtml) >= 0
    toHaveClass: (className) ->
      @actual.hasClass className
    toHaveCss: (css) ->
      for prop in css
        return false if @actual.css(prop) isnt css[prop]
      return true
