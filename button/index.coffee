z = require 'zorium'
_ = require 'lodash'

colors = require '../colors.json'
Ripple = require '../ripple'

if window?
  require './index.styl'

getBackgroundColor = ({color, isFlat, isDisabled}) ->
  if not isFlat
    switch
      when isDisabled
        color.disabled
      else
        color.base

getTextColor = ({color, isFlat, isDisabled}) ->
  switch
    when isDisabled
      color.disabledText
    when isFlat
      color.base
    else
      color.text

getRippleColor = ({color, isFlat}) ->
  if isFlat
    color.base
  else
    color.text

getOverlayOpacity = ({isFlat, isHovered}) ->
  if isFlat
    switch
      when isHovered
        0.04
      else
        0
  else
    switch
      when isHovered
        0.08
      else
        0

getOverlayColor = ({color, isFlat}) ->
  if isFlat
    color.base
  else
    color.text

module.exports = class Button
  constructor: ->
    @state = z.state
      isHovered: false

  render: ({
    children
    onclick
    type
    color
    isDisabled
    isFlat
    isOutlined
    isFlex
  }) =>
    {isHovered} = @state.getValue()
    type ?= 'button'

    if isOutlined and not isFlat
      throw new Error 'isOutlined requires isFlat'

    if _.isString color
      color =
        base: "#{color}500"
        text: "#{color}500Text"

    color = _.assign {
      base: 'blue500'
      text: 'blue500Text'
      disabled: 'black12'
      disabledText: 'black26'
    }, color

    color = _.mapValues color, (col) ->
      if colors['$' + col]? then colors['$' + col] else col

    z '.zp-button',
      className: z.classKebab {
        isDisabled
        isFlat
        isOutlined
        isFlex
      }
      ontouchend: =>
        @state.set isHovered: false
      onmouseover: =>
        @state.set isHovered: true
      onmouseout: =>
        @state.set isHovered: false
      onclick: onclick
      z 'button.button',
        disabled: if isDisabled then true else undefined
        type: type
        style:
          background: getBackgroundColor {
            color
            isFlat
            isDisabled
          }
          color: getTextColor {color, isFlat, isDisabled}
        [
          z '.overlay',
            style:
              background: getOverlayColor {color, isFlat}
              opacity: getOverlayOpacity {
                isFlat
                isHovered
              }
          z Ripple, {
            color: getRippleColor {color, isFlat}
            opacity: if isFlat
              0.16
          }
        ].concat children
