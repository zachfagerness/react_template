#!/bin/sh
echo "Please enter project name as it is on github:"
read NAME
mkdir $NAME
cd $NAME
git init
mkdir bin css src www
touch .babelrc .gitignore README.md webpack.config.js src/index.js www/index.html css/styles.css package.json
echo node_modules > .gitignore
echo .DS_store >> .gitignore
echo {\"presets\": [\"react\", \"es2015\"]} > .babelrc
cat <<EOT >> README.md
# Test project
This is where I test lots of new things and find ways to make stuff work.
It is likely this whole repo will be deleted every once in a while.
EOT
cat <<EOT >> package.json
{
  "name": "$NAME",
  "version": "1.0.0",
  "description": "React Webpack template with css loader and hot reload",
  "main": "www/index.html",
  "scripts": {
    "pro": "node_modules/.bin/webpack",
    "dev": "node_modules/.bin/webpack-dev-server"
  },
  "repository": {
    "type": "git",
    "url": "git+https://github.com/zachfagerness/$NAME.git"
  },
  "author": "zach fagerness",
  "license": "MIT",
  "bugs": {
    "url": "https://github.com/zachfagerness/$NAME/issues"
  },
  "homepage": "https://github.com/zachfagerness/$NAME#readme",
  "dependencies": {
  },
  "devDependencies": {
  }
}
EOT
npm i css-loader react react-dom style-loader --save
npm i babel-core babel-loader babel-preset-es2015 babel-preset-react webpack webpack-dev-server --save-dev
cat <<EOT >> www/index.html
<!doctype html>
<html>
  <head>
    <meta content="
    user-scalable=no,
    initial-scale=1,
    maximum-scale=1,
    minimum-scale=1,
    width=device-width"
    name="viewport">
    <meta http-equiv="Content-Security-Policy"/>
  </head>
  <body>
    <div id="ReactTarget"></div>
    <script src="bundle.js"></script>
  </body>
</html>
EOT
cat <<EOT >> src/index.js
import React,{Component} from 'react';
import ReactDOM from 'react-dom';
import styles from '../css/styles.css';

class Root extends Component{
  render(){
    return(
      <div><input type="button" className="btn" value="Button"></input></div>
    )
  }
}
ReactDOM.render(
  <Root />,
  document.getElementById('ReactTarget')
);
EOT
cat <<EOT >> webpack.config.js
const path = require('path');
const webpack = require('webpack');
module.exports = {
    entry: [
      './src/index.js'
    ],
    devServer: {
      hot:true,
      contentBase: 'www'
    },
    output: {
        path: path.resolve(__dirname, '/www'),
        filename: 'bundle.js'
    },
    plugins: [
      new webpack.HotModuleReplacementPlugin()
    ],
     module: {
         loaders: [
           {
               test: /\.js$/,
               exclude: /node_modules/,
               loader: 'babel-loader'
           },
           { test: /\.css$/, loader: "style-loader!css-loader" }
         ]
     }
};
EOT
cat <<EOT >> css/styles.css
.btn{
  color:red;
}
EOT
git add .
git commit -m "Template Init Commit"
git remote add origin https://github.com/zachfagerness/$NAME.git
git push -u origin master
npm run dev
