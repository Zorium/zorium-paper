z = require 'zorium'

paperColors = require '../colors.json'
styles = require './index.styl'

module.exports = class Input
  constructor: ({@o_value, @o_error} = {}) ->
    styles.use()

    @o_value ?= z.observe ''
    @o_error ?= z.observe null

    @o_isFocused = z.observe false

    @state = z.state {
      isFocused: @o_isFocused
      value: @o_value
      error: @o_error
    }

  render: ({colors, hintText, isFloating, isDisabled, isDark}) =>
    {value, error, isFocused} = @state()

    colors ?= {
      c500: paperColors.$black
    }
    hintText ?= ''
    isFloating ?= false
    isDisabled ?= false

    z '.z-input',
      className: z.classKebab {
        isDark
        isFloating
        hasValue: value isnt ''
        isFocused
        isDisabled
        isError: error?
      }
      z '.hint', hintText
      z 'input.input',
        attributes:
          disabled: if isDisabled then true else undefined
        value: value
        oninput: z.ev (e, $$el) =>
          @o_value.set $$el.value
        onfocus: z.ev (e, $$el) =>
          @o_isFocused.set true
        onblur: z.ev (e, $$el) =>
          @o_isFocused.set false
      z '.underline',
        style:
          backgroundColor: if isFocused and not error? \
                           then colors.c500 else null
      if error?
        z '.error', error
