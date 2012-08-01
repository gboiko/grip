session = require('../../Session/session')
[mysql,redis] = require('../../Utils/database')

class Register
    constructor: (@user) ->
        console.log('Loaded')
        @method = @user.request.method
        @request = @user.request
        @response = @user.response

    register: ->
        if @method == 'POST' then @get_register_info()
        else if @method == 'GET' then @response.render('register')     

    get_register_info: ->
        login = @request.body.login
        console.log(login)
        redis.get('user:'+login+':uid',(err,uid) =>
            console.log(err,uid)
            if err then return @fail_register()
            if uid
                return @response.render('register',{error:'already exist'})
            @create_user()
        )
        
    create_user: () ->
        login = @request.body.login
        password = @request.body.password
        gender = @request.body.gender
        mysql.query('INSERT INTO users (login,password,avatar,gender) 
          VALUES(?,?,?,?)',[login,password,"/images/male_avatar.png",gender],
          @push_redis)
        
    push_redis: (err,data) =>
        uid = data.insertId
        login = @request.body.login
        password = @request.body.password
        gender = @request.body.gender
        privat_msg = @request.body.privat_msg
        friends_msg = @request.body.friends_msg
        all_msg = @request.body.all_msg
        redis.multi() 
          .set('user:'+uid+':login',login)
          .set('user:'+login+':uid',uid)
          .set('user:'+uid+':password',password)
          .hmset('userdata:'+uid,'gender',gender,'privat_msg',privat_msg,
            'friends_msg',friends_msg,'all_msg',all_msg,'avatar',
            '/images/male_avatar.png')
          .exec((err,reply)=> @insert_user(err,reply,uid))
    
    insert_user: (err,reply,uid) ->
        if err then return @fail_register()
        login = @request.body.login
        password = @request.body.password
        user_dict = [uid,@created,login,password]
        session.create_session(user_dict)
    
    created: (sid) =>
        @response.cookies_set('sid',sid,{})
        @response.redirect('main')

    fail_register: ->
        @response.redirect('error') 
        
exports = module.exports = Register 
