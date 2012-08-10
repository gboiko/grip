exports = module.exports = (input,next) ->
  data = JSON.parse(input.__data)
  [arg1,arg2...] = data
  [mod, func] = arg1.split('.', 2)
  input.data = [mod,func,true,arg2...]
  delete input.__data
  next()
  return
      