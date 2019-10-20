const express = require('express')
const { asyncMiddleware } = require('./middleware')
const { ping } = require('../routes/ping')

let app = null

const initApp = async () => {
  app = express()
  app.get('/ping', (req, resp) => asyncMiddleware(ping(), req, resp))
  await new Promise((resolve, reject) => app.listen(process.env.PORT, () => resolve))
}

const getApp = () => app

module.exports = {
  initApp,
  getApp
}
