path = require('path')
fs = require('fs')
mime = require('./mime')

class StaticStorage
    constructor: ->
        @static_cache = {}
      
    set: (key,value) ->
        @static_cache[key] = value
    
    get: (key) ->
        value = @static_cache[key]
        return value or false
    
    clean: ->
        @static_cache = {}
    
    remove: (key) ->
        delete @static_cache[key]

        
class FileRequest
    constructor: (fpath,@res,@rid,@staticer) ->
        @fpath = @make_path(fpath)
        @mime = @get_mime_type()
        @file = null
        @existed = storage.get(@fpath)
        if @existed then @get_stat()
        else @get_file()
   
    get_file: ->
        output = fs.readFile(@fpath,"binary",@read_out)
    
    read_out: (err,data) =>
        if err then return @put_error()
        @file = data
        @get_stat() 
    
    get_stat: ->
        fs.stat(@fpath,@resolve_stat)
    
    resolve_stat: (err,data) => 
        if err then return @put_error()
        @etag = '"'+data.ino+'-'+data.size+'-'+Date.parse(data.mtime)+'"'
        if @existed and not @file then @compare()
        else @place_storage()
    
    place_storage: ->
        storage.set(@fpath,[@etag,@file])    
        @answer_file(@file)
        
    compare: ->
        if @existed[0] == @etag then @answer_file(@existed[1])
        else @get_file()
    
    make_path: (fpath) ->
        return @staticer.sdir+fpath
    
    get_mime_type: ->
        pos = @fpath.lastIndexOf('.')+1
        ext = @fpath.slice(pos)
        return mime.contentTypes[ext]  
    
    put_error: ->
        @res.send('Got error, stopping')
        
    answer_file: (file) ->
        @res.send_file(file,@mime)
        
class StaticDispatcher
    constructor: () ->
        @sdir = path.normalize(__dirname+"/../../../..")
        @request_cache = [] 
                
    get_file: (fpath,res) ->
        instance = new FileRequest(fpath,res,@request_cache.length,this)
        @request_cache.push(instance)
    
    clean: (rid) ->
        @request_cache.splice(rid,1)
      
storage = new StaticStorage()
static_dispatcher = new StaticDispatcher()

exports = module.exports = static_dispatcher