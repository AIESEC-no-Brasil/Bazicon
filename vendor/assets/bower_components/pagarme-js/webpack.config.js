const path = require('path')

module.exports = {
  context: path.join(__dirname, './lib'),
  entry: './index.js',
  devtool: 'source-map',
  target: 'node',
  output: {
    path: __dirname,
    libraryTarget: 'commonjs2',
    filename: 'pagarme.js',
    sourceMapFilename: 'pagarme.js.map',
  },
  module: {
    loaders: [
      {
        test: /\.js$/,
        loader: 'babel',
        exclude: /node_modules/,
      },
      {
        test: /\.json$/,
        loader: 'json',
      },
    ],
    preLoaders: [
      {
        test: /\.js$/,
        loader: 'eslint',
        exclude: /node_modules/,
      },
    ],
  },
}

