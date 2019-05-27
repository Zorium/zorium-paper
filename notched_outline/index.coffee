_ = require 'lodash'
z = require 'zorium'

if window?
  require './index.styl'

animate = (fromValue, toValue, duration, set) ->
  diff = toValue - fromValue
  step = diff / duration
  startTime = null
  render = (t) ->
    unless startTime?
      startTime = t
    progress = t - startTime
    set fromValue + step * progress

    if progress < duration
      requestAnimationFrame render
    else
      set toValue

  requestAnimationFrame render

calculatePath = ({
  cornerWidth, leadingStrokeLength, radius, height, width, smallPathLength
}) ->
  {
    large: "
      M #{cornerWidth + leadingStrokeLength}, 1
      h #{-leadingStrokeLength}
      a #{radius}, #{radius} 0 0 0 #{-radius}, #{radius}
      v #{height - 2 * cornerWidth}
      a #{radius}, #{radius} 0 0 0 #{radius}, #{radius}
      h #{width - 2 * cornerWidth}
      a #{radius}, #{radius} 0 0 0 #{radius}, #{-radius}
      v #{-height + 2 * cornerWidth}
      a #{radius}, #{radius} 0 0 0 #{-radius}, #{-radius}
      h #{-width + 2 * cornerWidth + leadingStrokeLength + smallPathLength}
    "
    small: "
      M #{cornerWidth + leadingStrokeLength}, 1
      h #{smallPathLength}
    "
  }

module.exports = class NotchedOutline
  constructor: ->
    @d = ''
    @dSmall = ''
    @notchWidth = 0
    @targetPathLength = 0
    @targetSmallPathLength = 0
    @pathLength = 0
    @smallPathLength = 18
    @resize = _.throttle @_resize, 100

  afterMount: (@$$el) =>
    window.addEventListener 'resize', @resize
    # XXX: (~) first paint, component ready, second paint
    requestAnimationFrame =>
      requestAnimationFrame =>
        requestAnimationFrame =>
          @resize()

  beforeUnmount: =>
    window.removeEventListener 'resize', @resize
    @$$el = null

  _resize: =>
    @setNotchWidth @notchWidth

  # https://github.com/material-components/material-components-web/blob/master/packages/mdc-notched-outline/foundation.js
  setNotchWidth: (notchWidth) =>
    unless @$$el?
      return

    prevNotchWidth = @notchWidth
    @notchWidth = notchWidth

    $$large = @$$el.querySelector '.zp-notched-outline > svg > .large'
    $$small = @$$el.querySelector '.zp-notched-outline > svg > .small'
    unless $$large? and $$small?
      throw new Error '$$large and/or $$small not found'

    radius = 4
    {width, height} = @$$el.getBoundingClientRect()

    cornerWidth = radius + 1.2
    leadingStrokeLength = Math.abs(11 - cornerWidth)
    paddedNotchWidth = if @notchWidth is 0 then 0 else @notchWidth + 8

    {large, small} = calculatePath {
      cornerWidth
      leadingStrokeLength
      radius
      height
      width
      @smallPathLength
    }

    isInitial = @d is ''
    @d = large
    @dSmall = small
    $$large.setAttribute 'd', @d
    $$small.setAttribute 'd', @dSmall

    @pathLength = $$large.getTotalLength()
    paddedPrevNotchWidth = if prevNotchWidth is 0 then 0 else prevNotchWidth + 8
    prevPathLength = @pathLength - (paddedPrevNotchWidth - @smallPathLength)
    @targetPathLength = @pathLength - (paddedNotchWidth - @smallPathLength)
    prevSmallPathLength = if prevNotchWidth is 0 then @smallPathLength else 0
    @targetSmallPathLength = if notchWidth is 0 then @smallPathLength else 0

    if isInitial
      $$large.style.strokeDasharray = [@targetPathLength, @pathLength].join ' '
      $$small.style.strokeDasharray =
        [@targetSmallPathLength, @smallPathLength].join ' '
    else
      animate prevPathLength, @targetPathLength, 150, (x) =>
        $$large.style.strokeDasharray = [x, @pathLength].join ' '

      animate prevSmallPathLength, @targetSmallPathLength, 150, (x) =>
        $$small.style.strokeDasharray = [x, @smallPathLength].join ' '

  render: ({color, isFocused}) =>
    z '.zp-notched-outline',
      className: z.classKebab {isFocused}
      style:
        color: color
      innerHTML: """
      <svg>
        <path
          class="large"
          style="stroke-dasharray:#{@targetPathLength},#{@pathLength}"
          d="#{@d}"
        />
        <path
          class="small"
          style="stroke-dasharray:#{@targetSmallPathLength},#{@smallPathLength}"
          d="#{@dSmall}"
        />
      </svg>
      """
