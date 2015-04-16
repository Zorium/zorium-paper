z = require 'zorium'

paperColors = require '../colors.json'
RipplerService = require '../services/rippler'

if window?
  require './index.styl'

module.exports = class Checkbox
  constructor: ({isChecked} = {}) ->
    isChecked ?= false

    @state = z.state {
      isChecked
    }

  render: ({colors, isDisabled, isDark}) =>
    {isChecked} = @state.getValue()

    colors ?= {
      c500: paperColors.$black
    }
    isDisabled ?= false
    isDark ?= false

    checkboxColor = if isChecked and not isDisabled then colors.c500 \
                    else null
    rippleColor = switch
      when isChecked and isDark
        paperColors.$grey200
      when isChecked
        paperColors.$grey800
      else colors.c500

    z '.zp-checkbox',
      {
        className: z.classKebab {
          isDark
        }
        attributes:
          disabled: if isDisabled then true else undefined
          checked: if isChecked then true else undefined
        onmousedown: z.ev (e, $$el) =>
          unless isDisabled
            RipplerService.ripple {
              $$el
              color: rippleColor
              isSmall: true
            }
            @state.set isChecked: not @state.getValue().isChecked
      },
      z '.checkbox', {
        style:
          backgroundColor: checkboxColor
          borderColor: checkboxColor
      }
      z '.checkmark'
