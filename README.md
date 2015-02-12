core

Install:

```bash
npm install -S zorium-paper
```

Use these webpack loaders

```coffee
{ test: /\.coffee$/, loader: 'coffee' }
{ test: /\.json$/, loader: 'json' }
{
  test: /\.styl$/
  loader: 'style/useable!css!stylus?' +
          'paths[]=bower_components&paths[]=node_modules'
}
```


Usage:

```coffee
Button = require 'zorium-paper/button'
paperColors = require 'zorium-paper/colors.json'
$button = new Button
  text: 'click me'
```
