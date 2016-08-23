


fis.match('**.scss',{
    rExt: '.css', // from .scss to .css
    preprocessor : fis.plugin("autoprefixer",{
        "browsers": ["last 2 versions"]
    }),
    //其他预处理
    parser: fis.plugin('node-sass', {
        //fis-parser-sass option
        //if you want to use outputStyle option, you must install fis-parser-sass2 !
        outputStyle: 'expanded'
    })
})
