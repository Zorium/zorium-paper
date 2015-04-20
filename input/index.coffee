z = require 'zorium'
Rx = require 'rx-lite'

paperColors = require '../colors.json'

if window?
  require './index.styl'

module.exports = class Input
  constructor: ({@valueSubject, @errorSubject} = {}) ->
    @valueSubject ?= new Rx.BehaviorSubject ''
    @errorSubject ?= new Rx.BehaviorSubject null

    @isFocusedSubject = new Rx.BehaviorSubject false

    @state = z.state {
      isFocused: @isFocusedSubject
      value: @valueSubject
      error: @errorSubject
    }

  render: ({colors, hintText, type, isFloating, isDisabled, isDark}) =>
    {value, error, isFocused} = @state.getValue()

    colors ?= {
      c500: paperColors.$black
    }
    hintText ?= ''
    type ?= 'text'
    isFloating ?= false
    isDisabled ?= false

    z '.zp-input',
      className: z.classKebab {
        isDark
        isFloating
        hasValue: value isnt ''
        isFocused
        isDisabled
        isError: error?
      }
      z '.hint', {
        style:
          color: if isFocused and not error? \
                 then colors.c500 else null
      },
        hintText
      z 'input.input',
        attributes:
          disabled: if isDisabled then true else undefined
          type: type
        value: value
        oninput: z.ev (e, $$el) =>
          @valueSubject.onNext $$el.value
        onfocus: z.ev (e, $$el) =>
          @isFocusedSubject.onNext true
        onblur: z.ev (e, $$el) =>
          @isFocusedSubject.onNext false
      z '.underline',
        style:
          backgroundColor: if isFocused and not error? \
                           then colors.c500 else null
      if error?
        z '.error', error
