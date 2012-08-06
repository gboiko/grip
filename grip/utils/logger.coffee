['magenta','yellow','green','blue','cyan','red'].forEach((color)->
    String.prototype.__defineGetter__(color, (->
      options =
        'magenta' : '\u001b[35m'
        'yellow' : '\u001b[33m'
        'green' : '\u001b[32m'
        'blue' : '\u001b[34m'
        'cyan' : '\u001b[36m' 
        'reset' : '\u001b[0m'
        'red' : '\u001b[31m'
      return options[color]+this+options['reset']
    ))
)

logger = exports = module.exports = (str,isError = false) ->
  if isError
    console.log('[sinoi]'.magenta+' '+str.red)
  else
    console.log('[sinoi]'.magenta+' '+str)