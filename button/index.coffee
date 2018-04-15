z = require 'zorium'
_ = require 'lodash'

colors = require '../colors.json'
Ripple = require '../ripple'

if window?
  require './index.styl'

getBackgroundColor = ({color, isRaised, isActive, isHovered, isDisabled}) ->
  if isRaised and not isDisabled
    if isActive
      color.active
    else if isHovered
      color.hovered
    else
      color.base

getTextColor = ({color, isRaised, isDisabled}) ->
  if not isDisabled
    if isRaised
      color.text
    else
      color.base

getRippleColor = ({color, isRaised}) ->
  if isRaised
    color.text
  else
    color.base

module.exports = class Button
  constructor: ->
    @state = z.state
      isHovered: false
      isActive: false

  render: ({children, onclick, type, isDisabled, isRaised, color, isFlex}) =>
    {isHovered, isActive} = @state.getValue()
    type ?= 'button'
    color ?= 'blue'

    if _.isString color
      color =
        base: "#{color}500"
        hovered: "#{color}600"
        active: "#{color}700"
        text: "#{color}500Text"

    color = _.assign {text: colors["$#{color.base}Text"]}, color
    color = _.mapValues color, (col) ->
      if colors['$' + col]? then colors['$' + col] else col

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
