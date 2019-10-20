const asyncMiddleware = (fn, req, resp) => Promise.resolve(
  fn(req, resp))
  .then(res => resp.send(res))
  .catch(err => resp.status(500).send({ err: err.stack })
)

module.exports = {
  asyncMiddleware
}
