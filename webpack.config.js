const HtmlWebpackPlugin = require('html-webpack-plugin');
const AutoPrefixer = require('autoprefixer');
const ExtractTextPlugin = require('extract-text-webpack-plugin');
const CopyWebpackPlugin = require('copy-webpack-plugin');

const env = process.env.NODE_ENV;

let loaders = [];
let plugins = [];

loaders.push({
    test: /\.(png|gif|jpg)$/,
    loader: "url?limit=1&name=[path][name].[ext]&context=./src"
});

loaders.push([
    { 
        test: /\.woff(2)?(\?v=[0-9]\.[0-9]\.[0-9])?$/, 
        loader: "url-loader?limit=1&minetype=application/font-woff"
    },
    { 
        test: /\.(ttf|eot|svg)(\?v=[0-9]\.[0-9]\.[0-9])?$/, 
        loader: "file-loader"
    }
]);

if( env !== 'dev' ){
    
    loaders.push({
        test: /\.js$/,
        loader: 'uglify!babel'
    });

    loaders.push({
        test: /\.css$/,
        loader: ExtractTextPlugin.extract('style', 'css!postcss', {
            publicPath: '../'
        })
    });

    loaders.push({
        test: /\.scss$/,
        loader: ExtractTextPlugin.extract('style', 'css!postcss!sass', {
            publicPath: '../'
        })
    });

    plugins.push(new ExtractTextPlugin('css/index.css'));
}
else {
    loaders.push({
        test: /\.js$/,
        exclude: /node_modules/,
        loader: 'babel'
    });

    loaders.push({
        test: /\.scss$/,
        loader: 'style!css!postcss!sass'
    });

    loaders.push({
        test: /\.css$/,
        loader: 'style!css!postcss'
    });
}

loaders.push({
    test: /\.ejs$/,
    loader: 'ejs-compiled'
});

// loaders.push({
//     test: /\.ejs$/,
//     loader: 'ejs-tpl?variable=data&attrs[]=img:src!ejs-html'
// });
//
plugins.push(new CopyWebpackPlugin([{
    from: './src/img',
    to: './img'
}]));

plugins.push(new HtmlWebpackPlugin({
    title: '浙盐集团业务综合管理系统',
    template: 'src/index.ejs',
    filename: './index.html'
}));

// plugins.push(new HtmlWebpackPlugin({
//     title: '浙盐集团业务综合管理系统-登录',
//     template: 'src/login.ejs',
//     filename: './login.html'
// }))

module.exports = {
    entry: './src/js/app',
    output: {
        path: './dist',
        filename: 'js/app.js'
    },
    module: {
        loaders: loaders
    },
    plugins: plugins,
    postcss: function(){
        return [AutoPrefixer({ browsers: ['last 20 versions'] })]
    },
};