exports = module.exports = (output,next) ->
  session = output.__session
  uid = output.uid
  apply_data = (scid) ->
      if not scid then return next('stop')
      output.scid = scid
      next()      
      return
  session.get_socket(uid,apply_data)
  return this