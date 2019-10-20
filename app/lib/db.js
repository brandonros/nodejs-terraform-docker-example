const Promise = require('bluebird')
const pgp = require('pg-promise')({ promiseLib: Promise })

let db = null

const initDb = async () => {
  db = await pgp({
    host: process.env.PGBOUNCER_HOST,
    port: process.env.PGBOUNCER_PORT,
    user: process.env.POSTGRES_USER,
    password: process.env.POSTGRES_PASSWORD,
    database: process.env.POSTGRES_DB
  })
}

const getDb = () => db

module.exports = {
  initDb,
  getDb
}
