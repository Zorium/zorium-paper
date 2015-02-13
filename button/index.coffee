z = require 'zorium'

paperColors = require '../colors.json'
Ripple = require '../ripple'
styles = require './index.styl'

module.exports = class Button
  constructor: ->
    styles.use()

    @state = z.state
      backgroundColor: null
      $ripple: new Ripple()

  render: ({text, isDisabled, listeners, isRaised,
            isShort, isDark, isFlat, colors, onclick}) =>
    {$ripple, backgroundColor} = @state()

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

    z '.z-button',
      className: z.classKebab {
        isRaised
        isFlat
        isShort
        isDark
      }
      z '.button',
        {
          attributes:
            if isDisabled
              disabled: true
          onclick: onclick
          onmouseover: =>
            @state.set backgroundColor: colors.c600

          onmouseout: =>
            @state.set backgroundColor: colors.c500

          onmousedown: z.ev (e, $$el) =>
            @state.set backgroundColor: colors.c700
            $ripple.ripple {
              $$el
              color: colors.ink or colors.c200
              mouseX: e.clientX
              mouseY: e.clientY
            }

          onmouseup: z.ev (e, $$el) =>
            @state.set backgroundColor: colors.c600

          style:
            backgroundColor: if isDisabled then null else backgroundColor
            color: if isDisabled then null else colors.cText
        },
        text
