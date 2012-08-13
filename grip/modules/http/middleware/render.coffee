#load base modules
fs = require('fs')
eco = require("eco")
path = require('path')

#load configuration
config = require('../../../config/config')

class Render
    constructor: (@dirs) ->
        self = this
        @static_cache = {}
        @template_dir = path.normalize(__dirname+"/../../../")+@dirs.templates
        files = fs.readdirSync(@template_dir)
        files.forEach((file)=> 
            @write_file(file)
            fs.watch(@template_dir+file,(event,file)=>                
                if event == 'change' then @write_file(file)
            )
        )
    
    write_file: (file) ->
        file_data = fs.readFileSync(@template_dir+file,"utf-8")
        [name,ext] = file.split('.')
        @static_cache[name] = file_data.toString()
        console.log('file ',file,' added to cache')     
    
    
    render: (page,context,callback) ->
        page = @static_cache[page]
        if page
            output = eco.render(page,context)
            callback.send(output)
        else
            callback.send('login')
    
Render = new Render(config.dirs)    
exports = module.exports = Render