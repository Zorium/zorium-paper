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
    }

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
        value: value
        oninput: z.ev (e, $$el) ->
          onValue $$el.value
        onfocus: z.ev (e, $$el) =>
          @state.set
            isFocused: true
        onblur: z.ev (e, $$el) =>
          @state.set
            isFocused: false
      z '.underline',
        style:
          backgroundColor: if isFocused and not error? \
                           then colors["$#{color}500"]
      if error?
        z '.error', error
