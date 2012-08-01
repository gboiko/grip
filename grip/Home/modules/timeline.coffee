[mysql,redis] = require('../../Utils/database')

class Timeline
    constructor: (@user) ->
        @method = @user.request.method
        @request = @user.request
        @response = @user.response
    
    get_feeds: ->
        redis.LRANGE('user:'+@user.uid+':watching',0,-1,@get_links)
    
    get_links: (err,reply) =>
        if err then return @user.socket(['timeline.error','fail_fetch'])
        query = 'uid='+reply[0]
        for user in reply[1..reply.length]
            query += ' OR uid='+user
        mysql.query('SELECT*FROM links WHERE '+query,@parse_links)
    
    parse_links: (err,reply) =>
        if err then return @user.socket(['timeline.error','fail_parse'])
        @user.socket(['timeline.set_feeds',reply])
    
        
exports = module.exports = Timeline