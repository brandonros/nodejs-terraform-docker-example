const Promise = require('bluebird')
const { initDb } = require('./lib/db')
const { initCache } = require('./lib/cache')
const { initBrowser } = require('./lib/browser')
const { initApp } = require('./lib/app')

const run = async () => {
  // wait for services to come up from docker network
  await Promise.delay(1000 * 10)
  // init connections to services
  await Promise.all([
    initDb(),
    initCache(),
    initBrowser()
  ])
  // init routes
  await initApp()
  console.log('Listening...')
}

process.on('unhandledRejection', (err) => {
  console.error(err)
  process.exit(1)
})

run()
