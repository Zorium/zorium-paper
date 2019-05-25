_ = require 'lodash'
z = require 'zorium'
Rx = require 'rxjs/Rx'

colors = require '../colors.json'
Ripple = require '../ripple'

if window?
  require './index.styl'

module.exports = class RadioButton
  constructor: ({isChecked} = {}) ->
    isChecked ?= new Rx.BehaviorSubject false
    @isCheckedWrite = new Rx.ReplaySubject 1
    @isCheckedRead = Rx.Observable.merge isChecked, @isCheckedWrite

    @state = z.state
      isFocused: false
      isChecked: @isCheckedRead

  stream: => @isCheckedRead

  render: ({color, isDisabled, name, onclick} = {}) =>
    {isChecked, isFocused} = @state.getValue()

    color ?= 'blue'

    if _.isString color
      color =
        base: "#{color}500"

    color = _.assign {
      base: 'blue500'
      disabled: 'black12'
    }, color

    color = _.mapValues color, (col) ->
      if colors['$' + col]? then colors['$' + col] else col

    z '.zp-radio-button',
      className: z.classKebab {
        isDisabled
        isChecked
        isFocused
      }
      z '.background',
        style:
          backgroundColor: if not isDisabled then color.base
      z '.ring',
        style:
          borderColor: if isChecked and not isDisabled then color.base
      z '.fill',
        style:
          backgroundColor: if not isDisabled then color.base
      z Ripple,
        color: color.base
      z 'input',
        type: 'radio'
        checked: if isChecked then true
        disabled: if isDisabled then true
        name: name
        onfocus: (e) =>
          @state.set
            isFocused: true
        onblur: (e) =>
          @state.set
            isFocused: false
        onclick: (e) ->
          e.preventDefault()
          onclick? e
