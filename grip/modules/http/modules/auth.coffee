http = require('http')  
session = require('../../session/session')

exports = module.exports = (req,res,next) ->
  set_authorized = (dict) ->
      req.auth = 
        state: 'authorized'
        uid : dict.uid
        userdata: dict
      next()
      return
  set_unauthorized = ->
      req.auth = 
          state : 'unauthorized'
          uid : false
          userdata: false
      next()
      return
  sid = req.cookies_get('sid')
  #if not sid then return set_unauthorized()
  connection =
      req: req
      res: res
      sid: sid
      set_unauthorized: set_unauthorized
      set_authorized : set_authorized
  session.get_session(connection)
  return this
