
routs = require('../../../config/routing')

class Route
    constructor: (@path,@params) ->
        @special_char =  /[|.+?{}()\[\]^$]/g
        @handler = @params.action or false
        @static = @params.static or false
        @dir = @params.dir or false
        @protected = @params.protected or false
        if @params.regexp then @clone_regexp()
        else @make_regexp() 
        
    clone_regexp: ->
        @route = new RegExp('^'+@path+'$')
    
    make_regexp: ->
        full_path = '^'
        full_path += @path.replace(@special_char, '\\$&')
          .replace(/\*\*\*/g, '([A-Za-z0-9-\/]+\.+[A-Za-z0-9-\/])')
          .replace(/\*\*/g, '(.*)')
          .replace(/\*/g, '([^/]*)')
        full_path += '$'
        @route = new RegExp(full_path)
          
class Router
    constructor: () ->
        @pusher = []
        @make_routs(routs,false)
            
    make_routs: (source,parent) ->
        for k,v of source
            if parent then full_path = parent+k
            else full_path = k 
            @pusher.push(new Route(full_path,v))
            if v.paths then @make_routs(v.paths,k)
                      
    get_handler: (path) ->
        for route in @pusher
            matches = route.route.exec(path)
            if matches
                if route.handler and not route.static
                    return [route.handler,route.protected,matches.slice(1)]
                else if not route.handler and route.static
                     return ['static',route.dir,matches.slice(1)]
        return ['error',false,false]

Router = new Router()            
exports = module.exports = Router
