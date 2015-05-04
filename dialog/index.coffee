z = require 'zorium'
_ = require 'lodash'

if window?
  require './index.styl'

module.exports = class Dialog
  render: ({title, $content, actions, onleave}) ->
    actions ?= []
    $content ?= ''
    onleave ?= (-> null)

    z '.zp-dialog',
      z '.backdrop', onclick: onleave
      z '.dialog',
        z '.info',
          if title
            z '.title', title
          z '.content', $content
        unless _.isEmpty actions
          z '.actions',
            _.pluck actions, '$el'
