import Kitura

let router = Router()

router.get("/api/resy") { request, response, next in
    response.send("Hello, Resy API!")
    next()
}

Kitura.addHTTPServer(onPort: 8080, with: router)
Kitura.run()