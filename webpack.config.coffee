path = require 'path'
webpack = require 'webpack'
autoprefixer = require 'autoprefixer'

module.exports =
  mode: 'development'
  devtool: 'inline-source-map'
  entry: './demo/index.coffee'
  output:
    path: path.resolve(__dirname, 'dist')
    filename: 'demo.bundle.js'
  resolve:
    extensions: ['.coffee', '.js', '.json', '.styl']
  module:
    rules: [
      {test: /\.coffee$/, loader: 'coffee-loader'}
      {test: /\.styl$/, use: [
        'style-loader'
        'css-loader'
        {
          loader: 'postcss-loader'
          options:
            sourceMap: true
            plugins: -> [autoprefixer({})]
        }
        'stylus-loader?paths[]=node_modules'
      ]}
    ]
  plugins: [
    new webpack.NamedModulesPlugin()
  ]
