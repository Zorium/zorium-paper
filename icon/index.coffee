z = require 'zorium'

paperColors = require '../colors.json'
RipplerService = require '../services/rippler'

if window?
  require './index.styl'

module.exports = class Icon
  render: ({icon, isDark, isInactive, shouldRipple}) ->
    icon ?= 'cake-variant'
    isDark ?= false
    shouldRipple ?= true

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
        }
        onmousedown: z.ev (e, $$el) ->
          if shouldRipple
            RipplerService.ripple {
              $$el
              color: rippleColor
              isSmall: true
            }
      },
      z '.icon',
        className: icon
