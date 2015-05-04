z = require 'zorium'
Rx = require 'rx-lite'

paperColors = require '../colors.json'
RipplerService = require '../services/rippler'

if window?
  require './index.styl'

module.exports = class RadioButton
  constructor: ({@isChecked} = {}) ->
    @isChecked ?= new Rx.BehaviorSubject(false)

    @state = z.state {
      isChecked: @isChecked
    }

  render: ({colors, isDisabled, isDark}) =>
    {isChecked} = @state.getValue()

    colors ?= {
      c500: paperColors.$black
    }
    isDisabled ?= false
    isDark ?= false

    rippleColor = switch
      when isChecked and isDark
        paperColors.$grey200
      when isChecked
        paperColors.$grey800
      else colors.c500

    z '.zp-radio-button',
      {
        className: z.classKebab {
          isDark
        }
        attributes:
          checked: if isChecked then true else undefined
          disabled: if isDisabled then true else undefined
        onmousedown: z.ev (e, $$el) =>
          unless isDisabled
            RipplerService.ripple {
              $$el
              color: rippleColor
              isSmall: true
            }
            @isChecked.onNext not isChecked
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
