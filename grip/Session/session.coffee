[mysql,redis] = require('../Utils/database')
crypto = require('crypto')

class Session
    constructor: ->
        console.log('Session manager started')
    
    get_session: (connection) ->
        redis.get('session:'+connection.sid+':sid',((err,reply)=> 
          @validate_session(err,reply,connection)
        ))
    
    validate_session: (err,uid,connection) ->
        if uid == 'false' or not uid
            @drop_cookie(connection.res)
            connection.set_unauthorized()
            return
        @get_userdata(uid,connection.set_authorized)
    
    create_session: (user_dict) ->
        [uid,next,login,password] = user_dict
        sid = @generate_sid(login,password)
        redis.SETEX('session:'+sid+':sid',7200,uid+'')
        next(sid)
                  
    generate_sid: (v1,v2) ->
        md5sum = crypto.createHash('md5')
        md5sum.update(v1+v2)
        return md5sum.digest('hex')
    
    drop_session: (sid,response) ->
        if sid then redis.DEL('session:'+sid+':sid')
        @drop_cookie(response)        
    
    drop_cookie: (response) ->
        response.cookies_drop('sid')
    
    bind_socket: (ws_input) ->
        redis.get('session:'+ws_input.sid+':sid',((err,reply)=> 
          @set_socket_uid(err,reply,ws_input)
        ))
            
    set_socket_uid: (err,uid,ws_input) ->
        if not uid or uid == 'false'
            return ws_input.fail(ws_input.socket)
        scid = ws_input.socket.id
        redis.SETEX('socket:'+scid+':uid',3600,uid+'')
        redis.SETEX('uid:'+uid+':socket',3600,scid+'')
        ws_input.pass(ws_input.socket)
    
    get_socket: (uid,next) ->
        redis.get('uid:'+uid+':socket',(err,scid)->
            if scid == 'false' or not scid then return next(false)
            return next(scid)
        )
    
    get_uid: (scid,next) ->
        redis.get('socket:'+scid+':uid',(err,uid)=>
            if uid == 'false' or not uid then return next(false)
            @get_userdata(uid,next)
        )      
    
    get_userdata: (uid,next) ->
        redis
            .multi()
            .get('user:'+uid+':login')
            .get('user:'+uid+':password')
            .hgetall('userdata:'+uid)
            .exec((err,response)=> @parse_userdata(err,response,uid,next))
    
    parse_userdata: (err,response,uid,next) ->
        if err then return next(false)
        dict = 
          login : response[0]
          password: response[1]
          data: response[2]
          uid: uid
        next(dict)
        return
        
Session = new Session()    
exports = module.exports = Session
