z = require 'zorium'

paperColors = require '../colors.json'
RipplerService = require '../services/rippler'
styles = require './index.styl'

module.exports = class Icon
  constructor: ->
    styles.use()

  render: ({icon, isDark, isInactive}) ->
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
        }
        onmousedown: z.ev (e, $$el) ->
          RipplerService.ripple {
            $$el
            color: rippleColor
            isSmall: true
          }
      },
      z '.icon',
        className: icon
