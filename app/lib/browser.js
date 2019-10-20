const puppeteer = require('puppeteer-core')

let browser = null

const initBrowser = async () => {
  browser = await puppeteer.connect({
    browserWSEndpoint: process.env.BROWSER_ENDPOINT
  })
}

const getBrowser = () => browser

module.exports = {
  initBrowser,
  getBrowser
}
