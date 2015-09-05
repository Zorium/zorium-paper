z = require 'zorium'
Rx = require 'rx-lite'

colors = require '../colors.json'
Ripple = require '../ripple'

if window?
  require './index.styl'

module.exports = class Checkbox
  constructor: ({@isChecked} = {}) ->
    @isChecked ?= new Rx.BehaviorSubject(false)

    @$ripple = new Ripple()

    @state = z.state {
      isChecked: @isChecked
    }

  render: ({color, isDisabled, onToggle}) =>
    {isChecked} = @state.getValue()
    color ?= 'blue'
    isDisabled ?= false

    checkboxColor = if isChecked and not isDisabled
      colors["$#{color}500"]
    else
      undefined

    rippleColor = if isChecked
      colors.$grey800
    else
      colors["$#{color}500"]

    z '.zp-checkbox',
      {
        attributes:
          disabled: if isDisabled then true else undefined
          checked: if isChecked then true else undefined
        onmousedown: z.ev (e, $$el) ->
          unless isDisabled
            onToggle(not isChecked)
      },
      z @$ripple, {color: rippleColor, isCenter: true, isCircle: true}
      z '.checkbox',
        style:
          backgroundColor: checkboxColor
          borderColor: checkboxColor
      z '.checkmark'
