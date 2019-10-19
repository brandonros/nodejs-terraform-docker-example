const { Client } = require('pg')
const redis = require('redis')
const express = require('express')

const delay = (ms) => new Promise(resolve => setTimeout(resolve, ms))

const initDb = async () => {
  const dbClient = new Client({
    host: process.env.POSTGRES_HOST,
    port: process.env.POSTGRES_PORT,
    user: process.env.POSTGRES_USER,
    password: process.env.POSTGRES_PASSWORD,
    database: process.env.POSTGRES_DB
  })
  await dbClient.connect()
  return dbClient
}

const initCache = async () => {
  const redisClient = redis.createClient(process.env.REDIS_PORT, process.env.REDIS_HOST)
  await new Promise(function (resolve, reject) {
    redisClient.on('ready', resolve)
    redisClient.on('error', reject)
  })
  return redisClient
}

const initApp = () => {
  const app = express()
  app.get('/ping', (req, res) => {
    res.send('pong')
  })
  app.listen(process.env.PORT, () => console.log('Listening...'))
  return app
}

const run = async () => {
  // wait for services to come up from docker network
  await delay(1000 * 30)
  const [db, cache] = await Promise.all([
    initDb(),
    initCache()
  ])
  const app = initApp()
}

run()
