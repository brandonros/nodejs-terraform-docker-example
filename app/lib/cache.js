const Promise = require('bluebird')
const redis = require('redis')

let cache = null

const initCache = async () => {
  Promise.promisifyAll(redis.RedisClient.prototype)
  Promise.promisifyAll(redis.Multi.prototype)
  cache = redis.createClient(process.env.REDIS_PORT, process.env.REDIS_HOST)
  await new Promise((resolve, reject) => {
    cache.once('ready', resolve)
    cache.once('error', reject)
  })
}

const getCache = () => cache

module.exports = {
  initCache,
  getCache
}
