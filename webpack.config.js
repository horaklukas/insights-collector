var webpack = require('webpack');
var path = require('path');

var TARGET_ENV = process.env.NODE_ENV ? process.env.NODE_ENV : 'development';

console.log('Target environment is', TARGET_ENV);

module.exports = {
  entry: {
    app: [
      './src/index.js'
    ]
  },

  output: {
    path: path.resolve(__dirname + '/dist'),
    filename: '[name].js',
  },

  module: {
    loaders: [
      {
        test: /\.less$/,
        loader: 'style!css!less'
      },
      {
        test:    /\.html$/,
        exclude: /node_modules/,
        loader:  'file?name=[name].[ext]',
      },
      {
        test:    /\.elm$/,
        exclude: [/elm-stuff/, /node_modules/],
        loader:  'elm-webpack',
      },
      {
        test: /\.woff(2)?(\?v=[0-9]\.[0-9]\.[0-9])?$/,
        loader: 'url-loader?limit=10000&minetype=application/font-woff',
      },
      {
        test: /\.(ttf|eot|svg)(\?v=[0-9]\.[0-9]\.[0-9])?$/,
        loader: 'file-loader',
      },
    ],

    noParse: /\.elm$/,
  },

  plugins: [
    new webpack.DefinePlugin({
      API_URL: TARGET_ENV === 'production' ? '"."' : '"http://localhost:4000"'
    })
  ],

  devServer: {
    inline: true,
    stats: { colors: true },
  },

};