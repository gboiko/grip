fs = require('fs')
path = require('path')
basename = path.basename

class Connector
    constructor: (connector) ->
        @response = connector.response
        @request = connector.request
        @ws_out = @app.ws_out
    
    send: (data) ->
        if @response then @response.send(data)
        @remove()
        
    json: (data) ->
        if @response then @response.json(data)
        @remove()
                
    redirect: (page) ->
        if @response then @response.redirect(page)
        @remove()
                        
    render: (template,context) ->
        if @response then @response.render(template,context)
        @remove()
    
    socket: (uid,data) ->
        if not data
            data = JSON.stringify(uid)
            uid = @uid
        else
            data = JSON.stringify(data)
        @ws_out(uid,data)
        @remove()

class User extends Connector
    constructor: (connector) ->
        super(connector)
        @dispatcher = modules.apply(this)
        console.log(@route)
        @init()
    
    init: ->
        [mod,func,secured,args...] = @route
        console.log(mod,func,secured,args...)
        if secured and not @logged then @redirect('login')
        else @dispatcher[mod][func](args)
                      
class GuestUser extends User
    constructor: (connector,@app) ->
        @userdata = false
        @uid = false
        @logged = false
        @route = connector.route
        @app.guest_users[this] = true
        super(connector)
            
    remove: ->
        delete @app.guest_users[this]
                              
class DelegatedUser extends User    
    constructor: (connector,@app) ->
        @userdata = connector.userdata
        @uid = @userdata.uid
        @logged = true
        @route = connector.route
        @app.delegated_users[this] = true
        super(connector)
    
    remove: ->
        delete @app.delegated_users[this]    
    
    
class HttpInput
    constructor: (request,response,app) ->
        connector =
          request: request
          response: response
          route: request.routing
          userdata: request.auth.userdata
        delete request.auth.userdata
        if request.auth.state == 'unauthorized'
            new GuestUser(connector,app)
            return 
        else 
            new DelegatedUser(connector,app)
            return 
    

class WsInput
    constructor: (input,app) ->
        connector =
          request: false
          response: false
          route: input.data
          userdata: input.userdata
        new DelegatedUser(connector,app)
        return
        
class ModuleLoader
    constructor: ->
        @modules = {}
        fs.readdirSync(__dirname + '/modules').forEach((filename) =>
            if (!/\.coffee$/.test(filename)) then return
            name = basename(filename, '.coffee')
            @modules[name] = require('./modules/' + name)
        )
    
    apply: (user) ->
        dict = {}
        for module,klass of @modules
            dict[module] = new klass(user)
        return dict

modules = new ModuleLoader()

exports.HttpInput = HttpInput
exports.WsInput = WsInput

