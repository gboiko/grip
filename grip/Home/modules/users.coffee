[mysql,redis] = require('../../Utils/database')

class Users
    constructor: (@user) ->
        @method = @user.request.method
        @request = @user.request
        @response = @user.response
    
    get: ->
        mysql.query('select*from users',@parse_all_get)
    
    parse_all_get: (err,data) =>
        if err then return @user.socket(['users.error','fetch_error'])
        redis.LRANGE('user:'+@user.uid+':watching',0,-1,(err,reply)=>
            res_dict = []
            for user in data
                obj = 
                  uid : user.uid
                  login: user.login
                  avatar: user.avatar
                if user.uid.toString() in reply
                  obj.watching = true
                else 
                  obj.watching = false
                res_dict.push(obj)
            @user.socket(['users.all',res_dict])
        )
        
    
    watch: (args) ->
        watching = args[0]
        mysql.query('INSERT INTO watcher(uid,watcher) VALUES(?,?)',
          [watching,@user.uid])
        redis.multi()
          .LPUSH('user:'+watching+':watchers',@user.uid)
          .LPUSH('user:'+@user.uid+':watching',watching)
          .exec()
    
exports = module.exports = Users