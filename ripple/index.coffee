z = require 'zorium'
_ = require 'lodash'
Rx = require 'rxjs/Rx'

colors = require '../colors.json'

if window?
  require './index.styl'

module.exports = class Ripple
  constructor: ->
    @state = z.state
      waves: []

  beforeUnmount: =>
    {waves} = @state.getValue()
    now = Date.now()

    # remove waves which have already started their animation
    @state.set
      waves: _.filter waves, ({startTime}) ->
        startTime + 100 > now

  render: ({color, opacity, isCircle, isCenter}) =>
    {waves} = @state.getValue()
    color ?= 'white'
    opacity ?= 0.32
    if colors["$#{color}500"]?
      color = colors["$#{color}500"]

    z '.zp-ripple',
      className: z.classKebab {isCircle}
      onmousedown: (e) =>
        {width, height, top, left} = e.currentTarget.getBoundingClientRect()

        if isCenter
          x = width / 2
          y = height / 2
        else
          x = e.clientX - left
          y = e.clientY - top

        startTime = Date.now()
        wave = {
          startTime: startTime
          $: z '.wave',
            key: startTime
            style:
              top: "#{y}px"
              left: "#{x}px"
              opacity: opacity
              background: "#{color}"
        }

        @state.set
          waves: waves.concat [wave]

        setTimeout =>
          {waves} = @state.getValue()
          @state.set
            waves: _.without waves, wave
        , 1400
      _.map waves, '$'
