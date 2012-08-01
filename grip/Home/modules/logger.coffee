session = require('../../Session/session')
[mysql,redis] = require('../../Utils/database')

class Logger
    constructor: (@user) ->
        @method = @user.request.method
        @request = @user.request
        @response = @user.response
        
    log_out: ->
        sid = @request.cookies_get('sid')
        session.drop_session(sid,@response)
        @user.redirect('login')
                
    log_in: ->
        if @method == 'POST' then @get_auth_info()
        else if @method == 'GET' then @user.render('login')
                
    get_auth_info: ->      
        @_login = @request.body.login or false
        @_password = @request.body.password or false
        redis.get('user:'+@_login+':uid',(err,uid)=>
            if err then return @fail_auth()
            @check_auth_info(err,uid)
        )
    
    check_auth_info: (err,uid) ->
        if err then return @fail_auth()
        if not uid then return @user.render('login',{error:'wrong name'})
        redis.get('user:'+uid+':password',(err,reply)=> 
            @valid_user(err,reply,uid)
        )
    
    valid_user: (err,password,uid) ->
        if err then @fail_auth()
        if password != @_password
            return @user.render('login',{error:'wrong password'})
        user_dict = [uid,@created,@_login,@_password]
        session.create_session(user_dict)
    
    created: (sid) =>
        @response.cookies_set('sid',sid,{})
        @user.redirect('main')
   
    fail_auth: ->
        @user.render('error') 
        
exports = module.exports = Logger  