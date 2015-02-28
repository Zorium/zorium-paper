z = require 'zorium'

paperColors = require '../colors.json'
RipplerService = require '../services/rippler'
styles = require './index.styl'

module.exports = class Button
  constructor: ->
    styles.use()

    @state = z.state
      backgroundColor: null

  render: ({text, isDisabled, listeners, isRaised,
            isShort, isDark, isFlat, colors, onclick, type}) =>
    {backgroundColor} = @state()

    type ?= 'button'
    isRaised ?= false
    isFlat = not isRaised
    isDisabled ?= false
    isDark ?= false
    onclick ?= (-> null)
    colors ?= {}
    colors = _.defaults colors, {
      cText: if colors.ink and not isDisabled \
                   then colors.ink
                   else null
      c200: paperColors.$grey800
      c500: null
      c600: null
      c700: null
      ink: null
    }
    backgroundColor ?= colors.c500

    z '.zp-button',
      className: z.classKebab {
        isRaised
        isFlat
        isShort
        isDark
      }
      z '.ripple-box',
        onmousedown: z.ev (e, $$el) =>
          @state.set backgroundColor: colors.c700
          RipplerService.ripple {
            $$el
            color: colors.ink or colors.c200
            mouseX: e.clientX
            mouseY: e.clientY
          }
        z 'input.button',
          {
            attributes:
              disabled: if isDisabled then true else undefined
              type: type
            value: text
            onclick: onclick
            onmouseover: =>
              @state.set backgroundColor: colors.c600

            onmouseout: =>
              @state.set backgroundColor: colors.c500

            onmouseup: z.ev (e, $$el) =>
              @state.set backgroundColor: colors.c600

            style:
              backgroundColor: if isDisabled then null else backgroundColor
              color: if isDisabled then null else colors.cText
          }
