z = require 'zorium'
_ = require 'lodash'
Rx = require 'rxjs/Rx'

colors = require '../colors.json'

if window?
  require './index.styl'

module.exports = class Ripple
  constructor: ->
    @state = z.state
      $waves: []
      waveKeyCounter: 0

  ripple: ({$$el, color, isCenter, mouseX, mouseY}) =>
    {$waves, waveKeyCounter} = @state.getValue()

    {width, height, top, left} = $$el.getBoundingClientRect()

    if isCenter
      x = width / 2
      y = height / 2
    else
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

  render: ({color, isCircle, isCenter}) =>
    {color, isCircle, isCenter, $waves} = @state.getValue()

    z '.zp-ripple',
      className: z.classKebab {isCircle}
      onmousedown: (e) =>
        @ripple {
          $$el: e.currentTarget
          color
          isCenter
          mouseX: e.clientX
          mouseY: e.clientY
        }
      $waves
