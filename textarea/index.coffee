z = require 'zorium'
Rx = require 'rxjs/Rx'

colors = require '../colors.json'

if window?
  require './index.styl'

module.exports = class Textarea
  constructor: ({value} = {}) ->
    value ?= new Rx.BehaviorSubject ''
    @valueWrite = new Rx.ReplaySubject 1
    @valueRead = Rx.Observable.merge @valueWrite, value

    @state = z.state {
      isFocused: false
      wasFocused: false
      error: null
      value: @valueRead
    }

  afterMount: (@$$el) => null
  beforeUnmount: =>
    @$$el = null
    @state.set
      isFocused: false
      wasFocused: false

  focus: =>
    if @$$el?
      $$input = @$$el.querySelector '.zp-textarea > .textarea'
      $$input.focus()

  wasFocused: => @state.getValue().wasFocused

  setError: (error) => @state.set {error}
  setValue: (value) => @valueWrite.next value

  stream: => @valueRead

  render: ({
    color
    label
    isDisabled
    name
    onblur
    onkeydown
    oninput
    tabindex
  }) =>
    {value, error, isFocused}  = @state.getValue()
    color ?= 'blue'
    label ?= ''
    isDisabled ?= false

    z '.zp-textarea',
      className: z.classKebab {
        hasValue: value? and value isnt ''
        isFocused
        isDisabled
        isError: error?
      }
      z '.hint', {
        style:
          color: if isFocused and not error? \
                 then colors["$#{color}500"]
      },
        label
      z '.border',
        style:
          borderColor: if isFocused and not error? \
                       then colors["$#{color}500"]
      z 'textarea',
        disabled: if isDisabled then true
        name: name
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
            wasFocused: true
        onblur: (e) =>
          @state.set
            isFocused: false
          onblur? e
        onkeydown: onkeydown
      if error?
        z '.error', error
