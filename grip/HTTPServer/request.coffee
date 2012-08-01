http = require('http') 
cookies = require('./middleware/cookies')

http.IncomingMessage.prototype.cookies_get = (field) ->
    return cookies.get(field,this)
    
