const { getDb } = require('../lib/db')
const { getCache } = require('../lib/cache')
const { getBrowser } = require('../lib/browser')

const ping = () => {
  return async (req, resp) => {
    const db = getDb()
    const cache = getCache()
    const browser = getBrowser()
    const [dbVersion, cacheInfo, browserVersion] = await Promise.all([
      db.query('SELECT version()'),
      cache.infoAsync(),
      browser.version()
    ])
    return {
      dbVersion,
      cacheInfo,
      browserVersion
    }
  }
}

module.exports = {
  ping
}
