class Cookies
    constructor: () ->
        console.log('Cookies manager initiated')
        @cookies_registry = {}
        
    get: (name,request) ->
        header = request.headers["cookie"]
        if not header then return
        
        match = header.match(@get_pattern(name))
        if not match then return
        
        value = match[1]
        return value
        
    set: (name,value,args,response) ->
        headers = response.getHeader("Set-Cookies") or []
        cookie = new Cookie(name,value,args)
        
        if typeof headers == 'string' then headers = [headers]
        headers.push(cookie.make_header())
        
        response.setHeader("Set-Cookie", headers)
        return
        
    get_pattern: (name) ->
        if @cookies_registry[name] then return @cookies_registry[name]
        @cookies_registry[name] = new RegExp("(?:^|;) *" +
          name.replace( /[-[\]{}()*+?.,\\^$|#\s]/g, "\\$&" ) +
          "=([^;]*)")
          
class Cookie
    constructor: (@name,value,args) ->
        @value = value or ""
        @path = args?.path or '/'
        @expires = args?.expires or false
        @domain = args?.domain or false
        @httponly = args?.httponly or false
        
    stringify: ->
        return @name+'='+@value
    
    make_header: ->
        header = @stringify()
        
        if @path then header +="; path="+ @path
        if @expires then header +="; expired=" + @expires
        if @domain then header +="; domain=" + @domain
        if @httponly then header +="; httponly"
        
        return header        

Cookies = new Cookies()
    
exports = module.exports = Cookies