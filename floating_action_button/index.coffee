z = require 'zorium'

paperColors = require '../colors.json'
Ripple = require '../ripple'
styles = require './index.styl'

module.exports = class FloatingActionButton
  constructor: ->
    styles.use()

    @state = z.state {
      $ripple: new Ripple()
    }

  render: ({$icon, colors, isMini, onclick}) =>
    {$ripple} = @state()

    isMini ?= false
    colors ?= {
      c500: paperColors.$black
    }

    z '.z-floating-action-button', {
      className: z.classKebab {isMini}
      onclick: onclick
      onmousedown: z.ev (e, $$el) ->
        $ripple.ripple {
          $$el
          color: paperColors.$white70
          mouseX: e.clientX
          mouseY: e.clientY
        }

      style:
        backgroundColor: colors.c500
    },
    z '.icon-container',
      $icon
