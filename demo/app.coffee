z = require 'zorium'

Button = require '../button'
Input = require '../input'
Textarea = require '../textarea'

if window?
  require './app.styl'

module.exports = class App
  $errorInput: ->
    $ = new Input()
    $.setError 'error message here'
    return $

  $errorTextarea: ->
    $ = new Textarea()
    $.setError 'error message here'
    return $

  render: ->
    [
      z 'head',
        z 'title', 'Demo'
        z 'link',
          href: 'https://fonts.googleapis.com/css?family=Roboto:300,400,500'
          rel: 'stylesheet'
      z 'body.app',
        z 'h1',
          'Zorium Paper - Demo'
        z 'h2',
          'Button'
        z '.set',
          z '.item',
            z Button,
              color: 'teal'
              'flat'
          z '.item',
            z Button,
              isDisabled: true
              color: 'red'
              'disabled'
          z '.item',
            z Button,
              isRaised: true
              color: 'green'
              'raised'
          z '.item',
            z Button,
              isRaised: true
              isDisabled: true
              color: 'orange'
              'raised disabled'
          z '.item',
            z Button,
              isRaised: true
              isDisabled: true
              color:
                disabled: 'brown500'
                disabledText: 'green500'
              'disabled color'
          z '.item',
            z Button,
              isRaised: true
              isFlex: true
              color: 'teal'
              'raised flex'
          z '.item',
            z Button,
              isRaised: true
              isFlex: true
              # https://github.com/fireflight1/mcg
              color:
                base: 'greenA700'
                hovered: '#00b657'
                active: '#00a24e'
                text: 'white'
              'custom color'
        z 'h2',
          'Input'
        z '.set',
          z '.item',
            z Input,
              color: 'deepPurple'
              label: 'flat'
          z '.item',
            z @$errorInput(),
              color: 'deepPurple'
              label: 'flat error'
          z '.item',
            z Input,
              color: 'deepPurple'
              label: 'disabled'
              isDisabled: true
          z '.item',
            z Input,
              color: 'orange'
              label: 'floating'
              isFloating: true
          z '.item',
            z @$errorInput(),
              color: 'orange'
              label: 'floating'
              isFloating: true
          z '.item',
            z Input,
              color: 'lightBlue'
              label: 'floating disabled'
              isFloating: true
              isDisabled: true
          z '.item',
            z Input,
              color: 'lightBlue'
              label: 'floating prefixed'
              isFloating: true
              $prefix:
                z 'div',
                  style:
                    width: '1em'
                    height: '1em'
                    background: 'red'
          z '.item',
            z Input,
              color: 'blue'
              label: 'boxed'
              isBoxed: true
          z '.item',
            z @$errorInput(),
              color: 'blue'
              label: 'error'
              isBoxed: true
          z '.item',
            z Input,
              color: 'blue'
              label: 'boxed disabled'
              isBoxed: true
              isDisabled: true
          z '.item',
            z Input,
              color: 'blue'
              label: 'floating boxed'
              isFloating: true
              isBoxed: true
          z '.item',
            z @$errorInput(),
              color: 'blue'
              label: 'floating boxed'
              isFloating: true
              isBoxed: true
          z '.item',
            z Input,
              color: 'blue'
              label: 'floating boxed disabled'
              isFloating: true
              isBoxed: true
              isDisabled: true
          z '.item',
            z Input,
              color: 'blue'
              label: 'floating boxed prefixed'
              isFloating: true
              isBoxed: true
              $prefix:
                z 'div',
                  style:
                    width: '1em'
                    height: '1em'
                    background: 'red'
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
              label: 'boxed disabled'
              isDisabled: true
    ]
