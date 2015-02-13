z = require 'zorium'

paperColors = require '../colors.json'
Ripple = require '../ripple'
styles = require './index.styl'

module.exports = class Checkbox
  constructor: ({isChecked} = {}) ->
    styles.use()

    isChecked ?= false

    @state = z.state {
      isChecked
      $ripple: new Ripple()
    }

  render: ({colors, isDisabled, isDark}) =>
    {isChecked, $ripple} = @state()

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

    z '.z-checkbox',
      {
        className: z.classKebab {
          isDark
        }
        attributes:
          disabled: if isDisabled then true else undefined
          checked: if isChecked then true else undefined
        onmousedown: z.ev (e, $$el) =>
          unless isDisabled
            $ripple.ripple {
              $$el
              color: rippleColor
              isSmall: true
            }
            @state.set isChecked: not @state().isChecked
      },
      z '.checkbox', {
        style:
          backgroundColor: checkboxColor
          borderColor: checkboxColor
      }
      z '.checkmark'
