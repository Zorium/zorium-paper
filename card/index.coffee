z = require 'zorium'

styles = require './index.styl'

module.exports = class Card
  constructor: ->
    styles.use()

  render: ({content}) ->
    z '.zp-card',
      z '.content', content
