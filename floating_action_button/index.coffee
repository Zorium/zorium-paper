z = require 'zorium'

paperColors = require '../colors.json'
Ripple = require '../ripple'
styles = require './index.styl'

module.exports = class FloatingActionButton
  constructor: ({$icon, colors, isMini, onclick}) ->
    styles.use()

    isMini ?= false
    colors ?= {
      c500: paperColors.$balck
    }

    @state = z.state {
      $icon
      colors
      isMini
      $ripple: new Ripple()
      listeners:
        onclick: onclick
    }

  render: ({$icon, colors, isMini, listeners, $ripple}) ->
    z '.z-floating-action-button', {
      className: z.classKebab {isMini}
      onclick: listeners.onclick
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
