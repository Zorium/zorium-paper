z = require 'zorium'
Rx = require 'rx-lite'

colors = require '../colors.json'
Ripple = require '../ripple'

if window?
  require './index.styl'

module.exports = class Checkbox
  constructor: ({@isChecked, @color, @isDisabled, @onToggle} = {}) ->
    if not @isChecked?.subscribe?
      @isChecked = new Rx.BehaviorSubject(@isChecked or false)

    if not @isChecked?.onNext? and not @onToggle?
      throw new Error 'Must use onToggle if isChecked not writeable'
    else if not @onToggle?
      @onToggle = (isChecked) -> @isChecked.onNext isChecked

    @color ?= 'blue'
    @isDisabled ?= false

    @$ripple = new Ripple()

    @state = z.state
      isChecked: @isChecked

  render: =>
    {isChecked} = @state.getValue()

    checkboxColor = if isChecked and not @isDisabled
      colors["$#{@color}500"]
    else
      undefined

    rippleColor = if isChecked
      colors.$grey800
    else
      colors["$#{@color}500"]

    z '.zp-checkbox',
      {
        attributes:
          disabled: if @isDisabled then true else undefined
          checked: if isChecked then true else undefined
        onmousedown: z.ev (e, $$el) =>
          unless @isDisabled
            @onToggle(not isChecked)
      },
      z @$ripple, {color: rippleColor, isCenter: true, isCircle: true}
      z '.checkbox',
        style:
          backgroundColor: checkboxColor
          borderColor: checkboxColor
      z '.checkmark'
