z = require 'zorium'

paperColors = require '../colors.json'
Ripple = require '../ripple'
styles = require './index.styl'

module.exports = class RadioButtom
  constructor: ({colors, isChecked, isDisabled, isDark}) ->
    styles.use()

    colors ?= {
      c500: paperColors.$black
    }
    isChecked ?= false
    isDisabled ?= false
    isDark ?= false

    @state = z.state {
      colors
      isChecked
      isDisabled
      isDark
      $ripple: new Ripple()
    }

  render: ({colors, isChecked, isDisabled, isDark, $ripple}) =>
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
