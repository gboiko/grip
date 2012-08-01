config = require('../../config/config')
logger = require('./logger')
mysql_driver = require('mysql')
redis = require('redis')

class MySQLManager
    constructor: () ->
        @conf = config.mysql
        @connection_timer = null
        @client = @make_connection()
        return @client
    
    make_connection: ->        
        client = mysql_driver.createConnection({
            user: @conf.user,
            password: @conf.password,
            debug: @conf.debug
        })
        client.connect()
        logger('Mysql connection established ... Apply database'.yellow)
        client.query('USE '+@conf.database)
        logger('Database applied'.yellow)
        @connection_timer = setTimeout((=>
            @refresh_connection()),@conf.restore_time
        )
        return client
    
    refresh_connection: ->
        @client.destroy()
        console.log('Restoring connection')
        clearTimeout(@connection_timer)
        @client = @make_connection()

class RedisManager
    constructor: () ->
        conf = config.redis
        db = redis.createClient()
        db.select(conf.db)
        logger('Redis applied'.yellow) 
        return db

mysql = new MySQLManager()
redis = new RedisManager()

exports = module.exports = [mysql,redis]
