#!/bin/sh
echo "Please enter project name as it is on github:"
read NAME
mkdir $NAME
echo  "\033[1;31m Created file $NAME \033[0m"
cd $NAME
git init
echo  "\033[1;31m Initilized Git \033[0m"
mkdir bin css src www
echo  "\033[1;31m Created Directories \033[0m"
touch .babelrc .gitignore README.md webpack.config.js src/index.js www/index.html css/styles.css package.json
echo  "\033[1;31m Created Files \033[0m"
echo node_modules > .gitignore
echo .DS_store >> .gitignore
echo {\"presets\": [\"react\", \"es2015\"]} > .babelrc
echo  "\033[1;31m Wrote .gitignore && .babelrc \033[0m"
cat <<EOT >> README.md
# Test project
This is where I test lots of new things and find ways to make stuff work.
It is likely this whole repo will be deleted every once in a while.
EOT
echo  "\033[1;31m Wrote README \033[0m"
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
echo  "\033[1;31m Wrote package.json && prepare to install node_modules \033[0m"
npm i css-loader react react-dom style-loader --save
npm i babel-core babel-loader babel-preset-es2015 babel-preset-react webpack webpack-dev-server --save-dev
echo  "\033[1;31m node_modules installed \033[0m"
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
echo  "\033[1;31m Wrote index.html \033[0m"
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
echo  "\033[1;31m Wrote index.js \033[0m"
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
        path: path.resolve(__dirname, 'bin'),
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
echo  "\033[1;31m Wrote webpack.config.js \033[0m"
cat <<EOT >> css/styles.css
.btn{
  color:red;
}
EOT
echo  "\033[1;31m Wrote styles.css \033[0m"
git add .
git commit -m "Template Init Commit"
git remote add origin https://github.com/zachfagerness/$NAME.git
git push -u origin master
echo  "\033[1;31m Commited to git && pushed to Github \033[0m"
npm run dev
