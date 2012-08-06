http = require('http')  
qs = require('querystring')


exports = module.exports = (req,res,next) ->
  if req.method == 'POST'
      body = ''
      req.setEncoding('utf8')
      req.on('data',(chunk)-> 
          body += chunk 
      )
      req.on('end',(-> 
          req.body = qs.parse(body)
          next()
      ))
  else 
      next()
  return this
