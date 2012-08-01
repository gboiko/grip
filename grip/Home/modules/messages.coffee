[mysql,redis] = require('../../Utils/database')

class Messages
    constructor: (@user) ->
        @method = @user.request.method
        @request = @user.request
        @response = @user.response
    
    send: (args) ->
        uid = args[0]
        msg = args[1]
        @user.socket(uid,['message.receive',msg])

exports = module.exports = Messages