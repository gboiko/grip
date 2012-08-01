LinkFetcher = require('../../Fetcher/linkfetcher')
[mysql,redis] = require('../../Utils/database')

class Link
    constructor: (@user) ->
        @method = @user.request.method
        @request = @user.request
        @response = @user.response
    
    preload: (args) ->
        LinkFetcher.get(args[0],@get_preloaded) 
            
    get_preloaded: (info) =>   
        
        if not info then return @user.socket(['feed.error','fail_preload'])
        info.push(@user.uid)
        mysql.query('INSERT INTO links (link,img,title,description,uid) 
          VALUES(?,?,?,?,?)',info,((err,data)=> @set_preload(err,data,info)))
    
    set_preload: (err,data,info) ->
        if err then return @user.socket(['feeds.error','no_link_preloaded'])
        [link,img,title,description,uid] = info
        obj =
          link  : link
          img   : img
          description : description
          title : title
          lid : data.insertId  
        @user.socket(['feeds.preloaded',obj])

    get_lids: ->
        mysql.query('SELECT*FROM links WHERE uid='+@user.uid,@parse_lids)
    
    parse_lids: (err,reply) =>
        console.log('link fetch',err,reply)
        if err then return @user.socket(['feeds.error','empty_link_set'])
        console.log(reply)
        @user.socket(['feeds.set_links',reply])
        return 
        
    remove: (lid) ->
        mysql.query('DELETE FROM links WHERE lid=?',lid)
    
    update: (args) ->
        mysql.query('UPDATE links SET title=?, description=? WHERE lid=?',args)
              
exports = module.exports = Link