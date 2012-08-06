config = require('../../config/config')
logger = require('./logger')

redis = require('redis')


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