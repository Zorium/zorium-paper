z = require 'zorium'

App = require './app'

require './root.styl'

STABILITY_TIMEOUT_MS = 1000

# NOTE: style-loader dynamically appends style elements to DOM at run-time
preserveStyles = (fn) ->
  styles = document.head.querySelectorAll 'style'
  fn()
  for style in styles
    document.head.appendChild style

init = ->
  if window.hasInitialized?
    return hotReload()
  else
    window.hasInitialized = true

  $app = new App()
  preserveStyles ->
    z.hydrate $app

hotReload = ->
  App = require './app'
  $app = new App()
  preserveStyles ->
    z.render (-> null), document.documentElement
    z.hydrate $app
#
if document.readyState is 'loading'
  document.addEventListener 'DOMContentLoaded', init
else
  init()

#############################
# ENABLE WEBPACK HOT RELOAD #
#############################

if module.hot
  module.hot.accept()
