http = require('http') 
render = require('./middleware/render')
cookies = require('./middleware/cookies')

http.OutgoingMessage.prototype.send = (data, code = 200) ->
  buffer = new Buffer(data)
  this.writeHead(code, {
      "Content-Type": "text/html; charset=utf-8"
      "Content-Length": buffer.length
      'X-Powered-By': 'Lobster'
  })  
  this.write(buffer)  
  this.end()
  return this
  
http.OutgoingMessage.prototype.json = (data, code = 200) ->
  json = JSON.stringify(data)
  this.writeHead(code, {
      "Content-Type": "application/json; charset=utf-8"
      'X-Powered-By': 'Lobster'
  })  
  this.write(json)  
  this.end()

http.OutgoingMessage.prototype.send_file = (data, type) ->
  this.writeHeader(200,{'Content-Type':type,'X-Powered-By': 'Lobster'})  
  this.write(data, 'binary')  
  this.end()
  

http.OutgoingMessage.prototype.redirect = (page) ->
  this.writeHead(302, {"Location": page})
  this.end()

http.OutgoingMessage.prototype.render = (page,context) ->
  render.render(page,context,this)

http.OutgoingMessage.prototype.cookies_set = (field,value) ->
  cookies.set(field,value,{},this)

http.OutgoingMessage.prototype.cookies_drop = (field) ->
  cookies.set(field,'',{expires: (new Date()).getTime()-3660},this)

