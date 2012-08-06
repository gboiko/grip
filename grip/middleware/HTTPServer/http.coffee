#base modules
http = require('http') 
util = require('util')

#load base proto
require('./request')
require('./response')

#load runtime middleware
middleware = [
  require('./middleware/routing'),
  require('./middleware/bodyparse'),
  require('./middleware/auth')
] 
    
class Server 
    constructor: (host,port,@handler) ->
        if not host or not port then return console.error('no address or port')
        http = http.createServer(@caller).listen(port,host)
        console.log(util.format('Server started on http://%s:%s',host,port))
        @index = 0
        return http 
                
    caller: (req,res) =>
        handler = @handler
        index = @index
        cycle = (params) ->
            if params == 'stop' then return
            next = middleware[index++]  
            if not next then return handler(req,res)
            next(req,res,cycle)
        middleware[index](req,res,cycle)
                
        
app = exports = module.exports = {}

app.createHttpServer = (handler) -> 
    this.listen = (host,port) ->
        if host and not isNaN(host)
            port = host
            host = 'localhost'
        else if host and not port
            port = 4333
            host = host
        else if not port and not host
            port = 4333
            host = 'localhost'
        http_server = new Server(host,port,handler)
        return http_server        
    return this

