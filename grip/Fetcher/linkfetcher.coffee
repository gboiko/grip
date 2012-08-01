[mysql,redis] = require('../Utils/database')
request = require('request')
crypto = require('crypto')

regexp =
    url : new RegExp('^(http://|https://)')
    host : new RegExp('^(http://|https://)(.*?)\/(.*)?','gi')

class Link
    constructor: (@link,callback,@linkfetcher) ->
        @callbacks = [callback]
        request.get(@link.link,((err,head,body)=> @parse_answer(err,head,body)))
    
    parse_answer: (err,head,body) ->
        info = @test_data(body)
        if not info then return @send_fail()
        @send_info(info)
        @destroy()
    
    test_data: (data) ->
        title_tag = new RegExp("<title>(\\s*)?(.*?)(\\s*)?<\/title>")
        logo_tag = new RegExp('<img.*?src="(.*?logo.*?)".*?>')
        img_tag = new RegExp('<img.*?src="(.*?)".*?>')
        description_tag = new RegExp('<meta.*?name="description".*?content="(.*?)".*?>','ig') 
        title = title_tag.exec(data)?[2] or false
        img = logo_tag.exec(data)?[1] or img_tag.exec(data)?[1] or false
        description = description_tag.exec(data)?[1] or false
        if title then return [title,img,description]
        return false
    
    send_info: (info) ->
        img = @normalize(info[1])
        link = [@link.link,img,info[0],info[2]]
        @dispatch_callbacks(link) 
    
    normalize: (img) ->
        if not img then return "/images/homer.png"
        have_header = regexp.url.test(img)
        if not have_header
            host = @fetch_host(@link.link)
            if not host then return "/images/homer.png"
            return host+img
        else return img
    
    fetch_host: (host) ->
        res = regexp.host.exec(host)
        if not res then return false
        return res[1]+res[2]+'/'
        
    send_fail: ->
        @dispatch_callbacks(false)
    
    dispatch_callbacks: (object) ->
        callback(object) for callback in @callbacks
    
    add_waiter: (callback) ->
        @callbacks.push(callback)
    
    destroy: () ->
        @linkfetcher.remove(@link.hash)
                 
class LinkFetcher
    constructor: () ->
        @register = {}
              
    get: (link,next) ->
        link = @normalize(link)
        pos_link = @register[link.hash]
        if pos_link then return pos_link.add_waiter(next)
        @create_new(link,next)

    create_new: (link,next) ->
        @register[link.hash] = new Link(link,next,this)
    
    normalize: (link) ->
        have_header = regexp.url.test(link)
        if have_header then link = link
        else link = 'http://'+link
        return {link : link, hash : @generate_hash(link) } 
    
    generate_hash: (link) ->
        md5sum = crypto.createHash('md5')
        md5sum.update(link)
        return md5sum.digest('hex')        
    
    remove: (hash) ->
        delete @register[hash]

linkfetcher = new LinkFetcher()

exports = module.exports = linkfetcher 