z = require 'zorium'
_ = require 'lodash'

colors = require '../colors.json'
Ripple = require '../ripple'

if window?
  require './index.styl'

getBackgroundColor = ({color, isRaised, isActive, isHovered, isDisabled}) ->
  if color and isRaised and not isDisabled
    if isActive
      colors["$#{color}700"]
    else if isHovered
      colors["$#{color}600"]
    else
      colors["$#{color}500"]

getTextColor = ({color, isRaised, isDisabled}) ->
  if not isDisabled
    if color and isRaised
      colors["$#{color}500Text"]
    else if color
      colors["$#{color}500"]

getRippleColor = ({color, isRaised}) ->
  if color and isRaised
    colors["$#{color}500Text"]
  else if color
    colors["$#{color}500"]

module.exports = class Button
  constructor: ->
    @state = z.state
      isHovered: false
      isActive: false

  render: ({children, onclick, type, isDisabled, isRaised, color, isFlex}) =>
    {isHovered, isActive} = @state.getValue()
    type ?= 'button'
    color ?= 'blue'

    backgroundColor = getBackgroundColor {
      color
      isRaised
      isActive
      isHovered
      isDisabled
    }
    textColor = getTextColor {color, isRaised, isDisabled}

    z '.zp-button',
      className: z.classKebab {
        isDisabled
        isHovered
        isActive
        isRaised
        isFlex
      }
      ontouchstart: =>
        @state.set isActive: true
      ontouchend: =>
        @state.set isActive: false, isHovered: false
      onmouseover: =>
        @state.set isHovered: true
      onmouseout: =>
        @state.set isHovered: false
      onmouseup: =>
        @state.set isActive: false
      onclick: (e) =>
        @state.set isHovered: false
        onclick?(e)
      onmousedown: =>
        @state.set isActive: true, isHovered: false
      z 'button.button',
        disabled: if isDisabled then true else undefined
        type: type
        style:
          background: backgroundColor
          color: textColor
        [
          z Ripple, {color: getRippleColor {color, isRaised}}
        ].concat children
