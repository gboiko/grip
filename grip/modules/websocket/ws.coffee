#base modules
io = require('socket.io')

#load user modules
session = require('../Session/session')

#load runtime middleware
input_middleware = [
  require('./middleware/auth'),
  require('./middleware/routing')
] 
output_middleware = [
  require('./middleware/convertor')
]


class Socket
    constructor: (@aux_in) ->
        console.log('Socket server inited')
        return this
        
    setup: (@http) ->
        @socket_server = io.listen(@http)
        @sockets = @socket_server.sockets.sockets
        @set_config()
        @emit_connector()
        return @prepare_send
        console.log('Socket server setuped and running')
        
    set_config: ->
        @socket_server.configure(=> @set_settings())
        
    set_settings: ->
        #@socket_server.set('authorization', @authorization)
        @socket_server.set('log level', 5)              
    
    authorization: (data,callback) =>
        sid = data.headers.cookie
        data.session = sid
        callback(null, true)
    
    emit_connector: ->
        @socket_server.sockets.on('connection', @handler)
         
    handler: (socket) =>
        console.log(socket.handshake)
        input =
          sid : socket.handshake.headers.cookie.replace('sid=','')
          socket : socket
          pass: @bind_events
          fail: @drop_socket
        session.bind_socket(input)
    
    drop_socket: (socket) =>
        socket.disconnect()
    
    bind_events: (socket) =>
        socket.on('signal',(data)=> @get_data(data,socket))
        socket.on('disconnect',(=> @get_disconnect(socket)))
    
    get_data: (data,socket) ->
        self = this
        index = 0
        input =
          __data : data
          __scid: socket.id
          __session: session
        cycle = (params) ->
            if params == 'stop' then return
            next = input_middleware[index++]  
            if not next then return self.aux_in(input)
            next(input,cycle)
        input_middleware[index](input,cycle)
    
    get_disconnect: (socket) ->
        console.log('socket ',socket.id,' droped')
    
    prepare_send: (uid,args) =>
        self = this
        index = 0
        output =
          data : args
          uid: uid
          __session: session
        cycle = (params) ->
            console.log(params)
            if params == 'stop' then return
            next = output_middleware[index++]  
            if not next then return self.send_data(output)
            next(output,cycle)
        output_middleware[index](output,cycle)
    
    send_data: (output) ->
        console.log(output)
        socket = @socket_server.sockets.sockets[output.scid]
        socket.emit('signal',output.data)

socket = exports = module.exports = {}

socket.createWSServer = (aux_in) ->
    Socket = new Socket(aux_in)
    this.listen = (http_server) ->
        send = Socket.setup(http_server)
        this.send = (uid,args) ->
            send(uid,args)
        return this
    return this
