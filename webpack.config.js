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
    rules: [
      {
        test: /\.less$/,
        use: [
          {
            loader: "style-loader"
          }, {
              loader: "css-loader"
          }, {
              loader: "less-loader"
          }
        ]
      },
      {
        test:    /\.html$/,
        exclude: /node_modules/,
        loader:  'file-loader?name=[name].[ext]',
      },
      {
        test:    /\.elm$/,
        exclude: [/elm-stuff/, /node_modules/],
        use: {
          loader:  'elm-webpack-loader',
        }
      },
      {
        test: /\.woff(2)?(\?v=[0-9]\.[0-9]\.[0-9])?$/,
        loader: 'url-loader?limit=10000&minetype=application/font-woff',
      },
      {
        test: /\.(ttf|eot|svg|gif)(\?v=[0-9]\.[0-9]\.[0-9])?$/,
        loader: 'file-loader',
      }
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