[mysql,redis] = require('../../Utils/database')

class Friends
    constructor: (@user) ->
        @method = @user.request.method
        @request = @user.request
        @response = @user.response

exports = module.exports = Friends