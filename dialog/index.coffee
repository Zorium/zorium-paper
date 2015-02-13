z = require 'zorium'
_ = require 'lodash'

styles = require './index.styl'

module.exports = class Dialog
  constructor: ->
    styles.use()

  render: ({title, content, actions, onleave}) ->
    actions ?= []
    content ?= ''
    onleave ?= (-> null)

    z '.z-dialog',
      z '.backdrop', onclick: onleave
      z '.dialog',
        z '.info',
          if title
            z '.title', title
          z '.content', content
        unless _.isEmpty actions
          z '.actions',
            _.pluck actions, '$el'
