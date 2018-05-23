_ = require 'lodash'
z = require 'zorium'
Rx = require 'rxjs/Rx'

colors = require '../colors.json'

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

# XXX
class NotchedOutline
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

  beforeUnmount: =>
    window.removeEventListener 'resize', @resize
    @$$el = null

  _resize: =>
    @setNotchWidth @notchWidth

  # https://github.com/material-components/material-components-web/blob/master/packages/mdc-notched-outline/foundation.js
  setNotchWidth: (notchWidth) =>
    prevNotchWidth = @notchWidth
    @notchWidth = notchWidth
    if prevNotchWidth is notchWidth and @d isnt ''
      return

    unless @$$el?
      throw new Error 'Component not yet mounted'

    $$large = @$$el.querySelector '.zp-input_notched-outline > svg > .large'
    $$small = @$$el.querySelector '.zp-input_notched-outline > svg > .small'
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
    z '.zp-input_notched-outline',
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

module.exports = class Input
  constructor: ({value} = {}) ->
    @stateSubscription = null
    value ?= new Rx.BehaviorSubject ''
    @valueWrite = new Rx.ReplaySubject 1
    @valueRead = Rx.Observable.merge @valueWrite, value

    @$notchedOutline = new NotchedOutline()

    @state = z.state {
      isFocused: false
      error: null
      value: @valueRead
    }

  afterMount: (@$$el) =>
    $$labelWidth = @$$el.querySelector '.zp-input > .input > .label-width'
    unless $$labelWidth?
      throw new Error '$$labelWidth not found'

    @stateSubscription = @state
      .distinctUntilChanged _.isEqual
      .subscribe ({isFocused, value}) =>
        requestAnimationFrame =>
          if isFocused or value? and value isnt ''
            @$notchedOutline.setNotchWidth \
              $$labelWidth.getBoundingClientRect().width
          else
            @$notchedOutline.setNotchWidth 0

  beforeUnmount: =>
    @stateSubscription?.unsubscribe()
    @$$el = null
    @state.set
      isFocused: false

  focus: =>
    if @$$el?
      $$input = @$$el.querySelector '.zp-input > .input > input'
      $$input.focus()

  setError: (error) => @state.set {error}
  setValue: (value) => @valueWrite.next value

  stream: => @valueRead

  render: ({
    color
    label
    helper
    isFilled
    isDisabled
    $icon
    type
    name
    autocapitalize
    autocomplete
    onblur
    onkeydown
    oninput
    tabindex
  }) =>
    {value, error, isFocused}  = @state.getValue()
    color ?= 'blue'
    label ?= ''
    type ?= 'text'
    isDisabled ?= false
    autocapitalize ?= 'none'
    hasValue = value? and value isnt ''

    z '.zp-input',
      className: z.classKebab {
        hasValue
        hasIcon: $icon?
        isFilled
        isFocused
        isDisabled
        isError: error?
      }
      z '.input',
        z '.label', {
          style:
            color: if isFocused and not error? \
                   then colors["$#{color}500"]
        },
          label
        z '.label-width', label
        if $icon?
          z '.icon',
            $icon
        z 'input',
          disabled: if isDisabled then true
          type: type
          autocapitalize: autocapitalize
          name: name
          autocomplete: autocomplete
          tabindex: tabindex
          value: value
          style:
            caretColor: unless error? then colors["$#{color}500"]
          oninput: (e) =>
            @valueWrite.next e.currentTarget.value
            oninput? e
          onfocus: =>
            @state.set
              isFocused: true
          onblur: (e) =>
            @state.set
              isFocused: false
            onblur? e
          onkeydown: onkeydown
        z '.underlines',
          z '.static'
          z '.dynamic',
            style:
              background: switch
                when error?
                  colors["$error"]
                when isFocused
                  colors["$#{color}500"]
        z @$notchedOutline,
          isFocused: isFocused
          # TODO: darken on hover
          color: switch
            when isDisabled
              colors['$black26']
            when error?
              colors["$error"]
            when isFocused
              colors["$#{color}500"]
            else
              colors['$black54']
      z '.helper',
        error or helper
