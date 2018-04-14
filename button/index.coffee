z = require 'zorium'
_ = require 'lodash'

colors = require '../colors.json'
Ripple = require '../ripple'

if window?
  require './index.styl'

getBackgroundColor = ({color, isRaised, isActive, isHovered, isDisabled}) ->
  if isRaised and not isDisabled
    if isActive
      colors["$#{color.active}"]
    else if isHovered
      colors["$#{color.hovered}"]
    else
      colors["$#{color.base}"]

getTextColor = ({color, isRaised, isDisabled}) ->
  if not isDisabled
    if isRaised
      colors["$#{color.base}Text"]
    else
      colors["$#{color.base}"]

getRippleColor = ({color, isRaised}) ->
  if isRaised
    colors["$#{color.base}Text"]
  else
    colors["$#{color.base}"]

module.exports = class Button
  constructor: ->
    @state = z.state
      isHovered: false
      isActive: false

  render: ({children, onclick, type, isDisabled, isRaised, color, isFlex}) =>
    {isHovered, isActive} = @state.getValue()
    type ?= 'button'
    color ?=
      base: 'blue500'
      active: 'blue700'
      hovered: 'blue600'

    if _.isString color
      color =
        base: "#{color}500"
        active: "#{color}700"
        hovered: "#{color}600"

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
          background: getBackgroundColor {
            color
            isRaised
            isActive
            isHovered
            isDisabled
          }
          color: getTextColor {color, isRaised, isDisabled}
        [
          z Ripple, {color: getRippleColor {color, isRaised}}
        ].concat children
