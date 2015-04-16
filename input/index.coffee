z = require 'zorium'

paperColors = require '../colors.json'

if window?
  require './index.styl'

module.exports = class Input
  constructor: ({@o_value, @o_error} = {}) ->
    @o_value ?= z.observe ''
    @o_error ?= z.observe null

    @o_isFocused = z.observe false

    @state = z.state {
      isFocused: @o_isFocused
      value: @o_value
      error: @o_error
    }

  render: ({colors, hintText, type, isFloating, isDisabled, isDark}) =>
    {value, error, isFocused} = @state.getValue()

    colors ?= {
      c500: paperColors.$black
    }
    hintText ?= ''
    type ?= 'text'
    isFloating ?= false
    isDisabled ?= false

    z '.zp-input',
      className: z.classKebab {
        isDark
        isFloating
        hasValue: value isnt ''
        isFocused
        isDisabled
        isError: error?
      }
      z '.hint', {
        style:
          color: if isFocused and not error? \
                 then colors.c500 else null
      },
        hintText
      z 'input.input',
        attributes:
          disabled: if isDisabled then true else undefined
          type: type
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
