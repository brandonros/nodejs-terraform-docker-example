const Promise = require('bluebird')
const pgp = require('pg-promise')({ promiseLib: Promise })
const redis = require('redis')
const express = require('express')
const puppeteer = require('puppeteer-core')

const delay = (ms) => new Promise(resolve => setTimeout(resolve, ms))

const initDb = async () => {
  const db = await pgp({
    host: process.env.PGBOUNCER_HOST,
    port: process.env.PGBOUNCER_PORT,
    user: process.env.POSTGRES_USER,
    password: process.env.POSTGRES_PASSWORD,
    database: process.env.POSTGRES_DB
  })
  return db
}

const initCache = async () => {
  Promise.promisifyAll(redis.RedisClient.prototype)
  Promise.promisifyAll(redis.Multi.prototype)
  const client = redis.createClient(process.env.REDIS_PORT, process.env.REDIS_HOST)
  await new Promise((resolve, reject) => {
    client.once('ready', resolve)
    client.once('error', reject)
  })
  return client
}

const initBrowser = async () => {
  const browser = await puppeteer.connect({
    browserWSEndpoint: process.env.BROWSER_ENDPOINT
  })
  return browser
}

const initApp = async (db, cache, browser) => {
  const app = express()
  app.get('/ping', (req, res) => {
    Promise.all([
      db.query('SELECT version()'),
      cache.infoAsync(),
      browser.version()
    ])
    .then(([dbVersion, cacheInfo, browserVersion]) => {
      res.send({
        dbVersion,
        cacheInfo,
        browserVersion
      })
    })
    .catch(err => {
      res.status(500).send({
        error: err
      })
    })
  })
  await new Promise((resolve, reject) => app.listen(process.env.PORT, process.env.HOST, () => resolve))
  return app
}

const run = async () => {
  // wait for services to come up from docker network
  await delay(1000 * 30)
  const [db, cache, browser] = await Promise.all([
    initDb(),
    initCache(),
    initBrowser()
  ])
  const app = await initApp(db, cache, browser)
}

process.on('unhandledRejection', (err) => {
  console.error(err)
  process.exit(1)
})

run()
