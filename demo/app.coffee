z = require 'zorium'
Rx = require 'rxjs/Rx'

Button = require '../button'
Input = require '../input'
RadioButton = require '../radio_button'
Textarea = require '../textarea'

if window?
  require './app.styl'

module.exports = class App
  $valueInput: (val) -> new Input({value: Rx.Observable.of val})

  $errorInput: ->
    $ = new Input()
    $.setError 'error message here'
    return $

  $errorTextarea: ->
    $ = new Textarea()
    $.setError 'error message here'
    return $

  $checkedRadioButton: -> new RadioButton {isChecked: Rx.Observable.of true}

  render: ->
    [
      z 'head',
        z 'title', 'Demo'
        z 'link',
          href: 'https://fonts.googleapis.com/css?family=Roboto:300,400,500'
          rel: 'stylesheet'
      z 'body',
        z '.app',
          z 'h1',
            'Zorium Paper - Demo'
          z 'h2',
            'Shadow'
          z '.set',
            _.map ['2', '3', '4', '6', '8', '12', '16', '24'], (n) ->
              z '.item',
                z '.card.shadow-' + n,
                  n
          z 'h2',
            'Font'
          z '.set',
            _.map [
              'h1', 'h2', 'h3', 'h4', 'h5', 'h6',
              'subtitle1', 'subtitle2', 'body1', 'body2',
              'button', 'caption', 'overline'
            ], (font) ->
              z '.item-block',
                z '.font-' + font,
                  font
                  ' - Hello World'
          z 'h2',
            'Button'
          _.map ['normal', 'isFlat', 'isOutlined'], (flavor) ->
            z '.set',
              z '.item',
                z Button,
                  isFlat: flavor is 'isFlat' or flavor is 'isOutlined'
                  isOutlined: flavor is 'isOutlined'
                  color: 'teal'
                  'normal'
              z '.item',
                z Button,
                  isFlat: flavor is 'isFlat' or flavor is 'isOutlined'
                  isOutlined: flavor is 'isOutlined'
                  # https://github.com/fireflight1/mcg
                  color:
                    base: 'greenA700'
                    hovered: '#00b657'
                    active: '#00a24e'
                    text: 'white'
                  'custom color'
              z '.item',
                z Button,
                  isFlat: flavor is 'isFlat' or flavor is 'isOutlined'
                  isOutlined: flavor is 'isOutlined'
                  isDisabled: true
                  color: 'red'
                  'disabled'
              z '.item',
                z Button,
                  isFlat: flavor is 'isFlat' or flavor is 'isOutlined'
                  isOutlined: flavor is 'isOutlined'
                  isDisabled: true
                  color:
                    disabled: 'brown500'
                    disabledText: 'green500'
                  'disabled color'
              z '.item',
                z Button,
                  isFlat: flavor is 'isFlat' or flavor is 'isOutlined'
                  isOutlined: flavor is 'isOutlined'
                  isFlex: true
                  color: 'teal'
                  'flex'
              z '.item',
                z Button,
                  isFlat: flavor is 'isFlat' or flavor is 'isOutlined'
                  isOutlined: flavor is 'isOutlined'
                  color: 'teal'
                  'x' # trigger min-width
          z 'h2',
            'Radio Button'
          z '.set',
            z '.item',
              z @$checkedRadioButton(),
                color: 'blue'
            z '.item',
              z @$checkedRadioButton(),
                isDisabled: true
                color: 'blue'
            z '.item',
              z RadioButton,
                color: 'orange'
            z '.item',
              z RadioButton,
                isDisabled: true
                color: 'teal'
          z 'h2',
            'Input'
          _.map ['normal', 'isFilled'], (flavor) =>
            z '.set',
              z '.item',
                z Input,
                  isFilled: flavor is 'isFilled'
                  color: 'deepPurple'
                  label: 'Normal'
                  helper: 'Helper'
              z '.item',
                z Input,
                  isFilled: flavor is 'isFilled'
                  color: 'orange'
                  label: 'Icon'
                  $icon: z 'div',
                    style:
                      width: '24px'
                      height: '24px'
                      background: 'red'
              z '.item',
                z Input,
                  isFilled: flavor is 'isFilled'
                  color: 'pink'
                  label: 'no helper'
              z '.item',
                style:
                  textAlign: 'right'
                z Input,
                  isFilled: flavor is 'isFilled'
                  color: 'lightBlue'
                  label: 'text-align right'
              z '.item',
                z @$valueInput('pre filled'),
                  isFilled: flavor is 'isFilled'
                  color: 'teal'
                  label: 'pre filled'
              z '.item',
                z @$errorInput(),
                  isFilled: flavor is 'isFilled'
                  color: 'deepPurple'
                  label: 'Error'
                  helper: 'helper'
              z '.item',
                z Input,
                  isFilled: flavor is 'isFilled'
                  color: 'deepPurple'
                  label: 'Disabled'
                  isDisabled: true
                  helper: 'helper'
          z 'h2',
            'Textarea'
          z '.set',
            z '.item.box',
              z Textarea,
                color: 'green'
                label: 'Textarea'
            z '.item.box',
              z @$errorTextarea(),
                color: 'blue'
                label: 'error'
            z '.item.box',
              z Textarea,
                color: 'orange'
                label: 'disabled'
                isDisabled: true
    ]
