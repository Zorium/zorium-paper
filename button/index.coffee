z = require 'zorium'
_ = require 'lodash'

colors = require '../colors.json'
Ripple = require '../ripple'

if window?
  require './index.styl'

getBackgroundColor = ({color, isRaised, isActive, isHovered, isDisabled}) ->
  if isRaised
    switch
      when isDisabled
        color.disabled
      when isActive
        color.active
      when isHovered
        color.hovered
      else
        color.base


getTextColor = ({color, isRaised, isDisabled}) ->
  switch
    when isDisabled
      color.disabledText
    when isRaised
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

    if _.isString color
      color =
        base: "#{color}500"
        hovered: "#{color}600"
        active: "#{color}700"
        text: "#{color}500Text"

    color = _.assign {
      base: 'blue500'
      hovered: 'blue600'
      active: 'blue700'
      text: 'blue500Text'
      disabled: 'rgba(0, 0, 0, 0.12)'
      disabledText: 'rgba(0, 0, 0, 0.26)'
    }, color

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
