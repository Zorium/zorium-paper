z = require 'zorium'
Rx = require 'rx-lite'

colors = require '../colors.json'
Ripple = require '../ripple'

if window?
  require './index.styl'

module.exports = class RadioButton
  constructor: ({@isChecked, color, isDisabled, onToggle} = {}) ->
    if not @isChecked?.subscribe?
      @isChecked = new Rx.BehaviorSubject(@isChecked or false)

    if not @isChecked?.onNext? and not onToggle?
      throw new Error 'Must use onToggle if isChecked not writeable'
    else if not onToggle?
      onToggle = (isChecked) => @isChecked.onNext isChecked

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

    z '.zp-radio-button',
      attributes:
        checked: if isChecked then true
        disabled: if isDisabled then true
      onmousedown: z.ev (e, $$el) ->
        unless isDisabled
          onToggle(not isChecked)
      z '.ring',
        style:
          borderColor: if isChecked and not isDisabled \
                       then colors["$#{color}500"]
      z '.fill',
        style:
          backgroundColor: if not isDisabled
            colors["$#{color}500"]
      @$ripple
