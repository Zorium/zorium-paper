z = require 'zorium'
_ = require 'lodash'

colors = require '../colors.json'
Ripple = require '../ripple'

if window?
  require './index.styl'

getBackgroundColor = ({color, isRaised, isActive, isHovered}) ->
  if color and isRaised
    if isActive
      colors["$#{color}700"]
    else if isHovered
      colors["$#{color}600"]
    else
      colors["$#{color}500"]
  else
    undefined

getTextColor = ({color, isRaised}) ->
  if color and isRaised
    colors["$#{color}500Text"]
  else if color
    colors["$#{color}500"]
  else
    undefined

getRippleColor = ({color, isRaised}) ->
  if color and isRaised
    colors["$#{color}500Text"]
  else if color
    colors["$#{color}200"]
  else
    undefined

module.exports = class Button
  constructor: ->
    @$ripple = new Ripple()

    @state = z.state
      backgroundColor: null
      isHovered: false
      isActive: false

  render: ({$children, onclick, type, isDisabled, isRaised, color}) =>
    {isHovered, isActive} = @state.getValue()
    onclick ?= -> null
    type ?= 'button'

    unless _.isArray $children
      $children = [$children]

    backgroundColor = getBackgroundColor {color, isRaised, isActive, isHovered}
    textColor = getTextColor {color, isRaised}
    rippleColor = getRippleColor {color, isRaised}

    z '.zp-button',
      className: z.classKebab {
        isDisabled
        isHovered
        isActive
        isRaised
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
        onclick(e)
      onmousedown: =>
        @state.set isActive: true, isHovered: false
      z 'button.button',
        attributes:
          disabled: if isDisabled then true else undefined
          type: type
        style:
          background: backgroundColor
          color: textColor
        [z @$ripple, {color: rippleColor}].concat $children
