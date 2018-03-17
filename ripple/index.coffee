z = require 'zorium'
_ = require 'lodash'
Rx = require 'rxjs/Rx'

colors = require '../colors.json'

if window?
  require './index.styl'

module.exports = class Ripple
  ripple: ({$$el, color, isCenter, mouseX, mouseY}) ->
    {width, height, top, left} = $$el.getBoundingClientRect()

    if isCenter
      x = width / 2
      y = height / 2
    else
      x = mouseX - left
      y = mouseY - top

    $$wave = document.createElement 'div'
    $$wave.className = 'wave'
    $$wave.style.top = "#{y}px"
    $$wave.style.left = "#{x}px"
    $$wave.style.background = "#{color}"

    $$el.appendChild $$wave

    setTimeout ->
      $$el.removeChild $$wave
    , 1400

  render: ({color, isCircle, isCenter}) =>
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
