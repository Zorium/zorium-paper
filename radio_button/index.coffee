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
    rippleColor = switch
      when isChecked and isDark
        paperColors.$grey200
      when isChecked
        paperColors.$grey800
      else colors.c500

    z '.z-radio-button',
      {
        className: z.classKebab {
          isDark
        }
        attributes:
          checked: if isChecked then true else undefined
          disabled: if isDisabled then true else undefined
        onmousedown: z.ev (e, $$el) =>
          unless isDisabled
            $ripple.ripple {
              $$el
              color: rippleColor
              isSmall: true
            }
            @state.set isChecked: not @state().isChecked
      },
      z '.ring', {
        style:
          borderColor: if isChecked and not isDisabled \
                       then colors.c500 else null
      }
      z '.fill', {
        style:
          backgroundColor: if not isDisabled then colors.c500 else null
      }
