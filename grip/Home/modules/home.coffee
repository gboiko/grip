class Home
    constructor: (@user) ->
    
    main: () ->
		    @user.render('main',{user:@user.userdata.login})   
    
    get_uid: (args...)->
        data = [2,3,'go to the next'] 
        data = JSON.stringify(data)
        @user.socket(data)
    
exports = module.exports = Home
