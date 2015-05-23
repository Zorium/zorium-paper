z = require 'zorium'

paperColors = require '../colors.json'
RipplerService = require '../services/rippler'

if window?
  require './index.styl'

module.exports = class Icon
  render: ({icon, isDark, isInactive, isTouchTarget, padding}) ->
    icon ?= 'cake-variant'
    isDark ?= false

    rippleColor = switch
      when isDark
        paperColors.$white
      else
        paperColors.$grey800

    z '.zp-icon',
      {
        className: z.classKebab {
          isDark
          isInactive
          isTouchTarget
        }
        style:
          padding: padding
        onmousedown: z.ev (e, $$el) ->
          if isTouchTarget
            RipplerService.ripple {
              $$el
              color: rippleColor
              isSmall: true
            }
      },
      z '.icon',
        className: icon
