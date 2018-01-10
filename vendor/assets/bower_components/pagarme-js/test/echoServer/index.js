import http from 'http'

import {
  pipe,
  pickAll,
  mergeAll,
  of,
  ap,
} from 'ramda'

import parseUrlAndBody from './parsers'

process.title = 'echoServer'

const port = process.env.PORT

const server = http.createServer((req, res) => {
  const chunks = []

  req.on('data', (chunk) => {
    chunks.push(chunk)
  })

  req.on('end', () => {
    res.writeHead(200, { 'Content-Type': 'application/json' })

    const headerAndMethod = pickAll(['headers', 'method'])

    const respond = pipe(
      of,
      ap([
        headerAndMethod,
        parseUrlAndBody(chunks),
      ]),
      mergeAll,
      JSON.stringify,
      res.end.bind(res)
    )

    respond(req)
  })
})

server.listen(port, () =>
  console.log(`Server started in port ${port}`))

process.on('SIGINT', () => process.exit(0))

