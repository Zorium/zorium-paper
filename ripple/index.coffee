z = require 'zorium'
_ = require 'lodash'

colors = require '../colors.json'

if window?
  require './index.styl'

module.exports = class Ripple
  constructor: ->
    @state = z.state
      $waves: []
      waveKeyCounter: 0

  ripple: ({$$el, color, mouseX, mouseY}) =>
    {$waves, waveKeyCounter} = @state.getValue()

    {width, height, top, left} = $$el.getBoundingClientRect()

    x = mouseX - left
    y = mouseY - top

    $wave =  z '.wave',
      key: waveKeyCounter
      style:
        top: y + 'px'
        left: x + 'px'
        backgroundColor: color

    @state.set
      $waves: $waves.concat $wave
      waveKeyCounter: waveKeyCounter + 1

    window.setTimeout =>
      {$waves} = @state.getValue()
      @state.set
        $waves: _.without $waves, $wave
    , 1400

  render: =>
    {$waves} = @state.getValue()

    z '.zp-ripple',
      onmousedown: z.ev (e, $$el) =>
        @ripple {
          $$el
          color: colors.$grey800
          mouseX: e.clientX
          mouseY: e.clientY
        }
      $waves
