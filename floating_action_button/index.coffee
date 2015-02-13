z = require 'zorium'

paperColors = require '../colors.json'
RipplerService = require '../services/rippler'
styles = require './index.styl'

module.exports = class FloatingActionButton
  constructor: ->
    styles.use()

  render: ({$icon, colors, isMini, onclick}) ->
    isMini ?= false
    colors ?= {
      c500: paperColors.$black
    }

    z '.zp-floating-action-button', {
      className: z.classKebab {isMini}
      onclick: onclick
      onmousedown: z.ev (e, $$el) ->
        RipplerService.ripple {
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
