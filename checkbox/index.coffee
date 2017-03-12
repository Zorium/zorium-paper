z = require 'zorium'
Rx = require 'rxjs/Rx'

colors = require '../colors.json'
Ripple = require '../ripple'

if window?
  require './index.styl'

module.exports = class Checkbox
  constructor: ({@isChecked, color, isDisabled, onToggle} = {}) ->
    if not @isChecked?.subscribe?
      @isChecked = new Rx.BehaviorSubject(@isChecked or false)

    if not @isChecked?.next? and not onToggle?
      throw new Error 'Must use onToggle if isChecked not writeable'
    else if not onToggle?
      onToggle = (isChecked) => @isChecked.next isChecked

    color ?= 'blue'
    isDisabled ?= false

    @$ripple = new Ripple {
      color: @isChecked.map (isChecked) ->
        if isChecked
          colors.$grey800
        else
          colors["$#{color}500"]
      isCenter: true
      isCircle: true
    }

    @state = z.state {
      @isChecked
      color
      isDisabled
      onToggle
    }

  render: =>
    {isChecked, color, isDisabled, onToggle} = @state.getValue()

    checkboxColor = if isChecked and not isDisabled
      colors["$#{color}500"]
    else
      undefined

    z '.zp-checkbox',
      attributes:
        disabled: if isDisabled then true
        checked: if isChecked then true
      onmousedown: z.ev (e, $$el) ->
        unless isDisabled
          onToggle(not isChecked)
      z '.checkbox',
        style:
          backgroundColor: checkboxColor
          borderColor: checkboxColor
      z '.checkmark'
      @$ripple
