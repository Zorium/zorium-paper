z = require 'zorium'
Rx = require 'rx-lite'

colors = require '../colors.json'

if window?
  require './index.styl'

readWriteStreams = (stream, onChange, defaultValue) ->
  if not stream?.subscribe?
    stream = new Rx.BehaviorSubject stream or defaultValue

  if not stream?.onNext? and not onChange?
    throw new Error 'Must use change handler if stream not writeable'
  else if not onChange?
    onChange = (value) -> stream.onNext value

  [stream, onChange]

module.exports = class Input
  constructor: ({
    @value
    @error
    onValue
    onError
    color
    label
    type
    isFloating
    isDisabled
    autocapitalize
    name
    autocomplete
  } = {}) ->
    [@value, onValue] = readWriteStreams @value, onValue, ''
    [@error, onError] = readWriteStreams @error, onError, null

    color ?= 'blue'
    label ?= ''
    type ?= 'text'
    isFloating ?= false
    isDisabled ?= false
    autocapitalize ?= 'none'

    @state = z.state {
      @value
      @error
      onValue
      onError
      color
      label
      type
      isFloating
      isDisabled
      autocapitalize
      isFocused: false
      wasFocused: false
      name
      autocomplete
    }

  afterMount: (@$$el) => null
  beforeUnmount: =>
    @$$el = null
    @state.set
      isFocused: false
      wasFocused: false

  focus: =>
    if @$$el?
      $$input = @$$el.querySelector '.zp-input > .input'
      $$input.focus()

  wasFocused: => @state.getValue().wasFocused

  render: =>
    {
      value
      error
      onValue
      onError
      color
      label
      type
      isFloating
      isDisabled
      autocapitalize
      isFocused
      name
      autocomplete
    } = @state.getValue()

    z '.zp-input',
      className: z.classKebab {
        isFloating
        hasValue: value isnt ''
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
      z 'input.input',
        attributes:
          disabled: if isDisabled then true
          type: type
          autocapitalize: autocapitalize
          name: name
          autocomplete: autocomplete
        value: value
        oninput: z.ev (e, $$el) ->
          onValue $$el.value
        onfocus: z.ev (e, $$el) =>
          @state.set
            isFocused: true
            wasFocused: true
        onblur: z.ev (e, $$el) =>
          @state.set
            isFocused: false
      z '.underline',
        style:
          backgroundColor: if isFocused and not error? \
                           then colors["$#{color}500"]
      if error?
        z '.error', error
