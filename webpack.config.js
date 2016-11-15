var path             = require("path");
var webpack          = require('webpack');
var LiveReloadPlugin = require('webpack-livereload-plugin');

var config = {
    entry: [
        './app/initialise.ts'
    ],
    output: {
        path: path.resolve(__dirname, 'public/static/js/build'),
        filename: 'bundle.js'
    },
    resolve: {
        extensions: ['', '.ts', '.tsx', '.js', '.jsx']
    },
    module: {
        loaders: [
            {
                test: /\.ts$/,
                loader: 'ts-loader',
                exclude: /node_modules/
            }
        ]
    },
    externals: {
        'backbone':            'Backbone',
        'backbone.marionette': 'Marionette',
        'jquery':              '$',
        'underscore':          '_'
    },
    plugins: [
        new LiveReloadPlugin({
            appendScriptTag: false
        })
    ]
};

module.exports = config;
