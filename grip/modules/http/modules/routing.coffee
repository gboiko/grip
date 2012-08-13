parse = require('url').parse
router = require('./../middleware/router')
static_dispatcher = require('./../middleware/static')

exports = module.exports = (req,res,next) ->
  path = parse(req.url).pathname
  [arg1,arg2,arg3...] = router.get_handler(path)
  if arg1 == 'static'
      path = arg2+arg3[0]
      static_dispatcher.get_file(path,res)
      next('stop')
      return
  if arg1 == 'error'
      res.send('missing rout')
      next('stop')
      return 
  [mod, func] = arg1.split('.', 2)
  req.routing = [mod,func,arg2,arg3]
  next()
  return
      
