exports = module.exports = (input,next) ->
  session = input.__session
  scid = input.__scid
  apply_data = (dict) ->
      if not dict then return next('stop')
      input.userdata = dict
      next()      
      return
  session.get_uid(scid,apply_data)
  return this
